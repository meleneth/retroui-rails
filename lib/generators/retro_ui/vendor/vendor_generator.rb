# frozen_string_literal: true

require "rails/generators"

module RetroUI
  module Generators
    class VendorGenerator < ::Rails::Generators::Base
      desc "Copy RetroUI Rails components into the host application."

      class_option :force, type: :boolean, default: false, desc: "Overwrite existing vendored files."

      COMPONENT_FILES = %w[
        button_component.rb
        button_component.html.erb
        card_component.rb
        card_component.html.erb
        card_header_component.rb
        card_header_component.html.erb
        card_title_component.rb
        card_title_component.html.erb
        card_description_component.rb
        card_description_component.html.erb
        card_content_component.rb
        card_content_component.html.erb
        badge_component.rb
        badge_component.html.erb
        alert_component.rb
        alert_component.html.erb
        alert_title_component.rb
        alert_title_component.html.erb
        alert_description_component.rb
        alert_description_component.html.erb
        input_component.rb
        input_component.html.erb
        textarea_component.rb
        textarea_component.html.erb
        label_component.rb
        label_component.html.erb
        checkbox_component.rb
        checkbox_component.html.erb
        radio_component.rb
        radio_component.html.erb
        select_component.rb
        select_component.html.erb
        separator_component.rb
        separator_component.html.erb
        skeleton_component.rb
        skeleton_component.html.erb
        progress_component.rb
        progress_component.html.erb
        table_component.rb
        table_component.html.erb
        table_header_component.rb
        table_header_component.html.erb
        table_body_component.rb
        table_body_component.html.erb
        table_footer_component.rb
        table_footer_component.html.erb
        table_row_component.rb
        table_row_component.html.erb
        table_head_component.rb
        table_head_component.html.erb
        table_cell_component.rb
        table_cell_component.html.erb
        table_caption_component.rb
        table_caption_component.html.erb
      ].freeze

      def copy_components
        COMPONENT_FILES.each do |filename|
          copy_with_namespace_rewrite(
            gem_root.join("app/components/retro_ui/rails/#{filename}"),
            destination_path.join("app/components/retro_ui/#{filename}")
          )
        end
      end

      def copy_theme
        copy_with_namespace_rewrite(
          gem_root.join("app/assets/stylesheets/retro_ui/rails/theme.css"),
          destination_path.join("app/assets/stylesheets/retro_ui/theme.css")
        )
      end

      def print_done
        say ""
        say "RetroUI components have been vendored into your app.", :green
        say "Future retroui-rails gem updates will not automatically alter these vendored copies."
      end

      private

      def copy_with_namespace_rewrite(source, destination)
        if destination.exist? && !options[:force]
          raise ::Rails::Generators::Error, "Refusing to overwrite #{relative_to_destination(destination)}. Re-run with --force to replace it."
        end

        empty_directory destination.dirname
        content = rewrite_content(source)
        create_file destination, content, force: options[:force]
        say "Copied #{relative_to_destination(destination)}"
      end

      def rewrite_content(source)
        content = source.read.gsub("RetroUI::Rails", "RetroUI")
        return content unless source.extname == ".rb"

        content = content.sub(/module RetroUI\n  module Rails\n    class ([^\n]+)\n/, "class RetroUI::\\1\n")
        content = content.sub(/\n    end\n  end\nend\n?\z/, "\nend\n")
        content = content.lines.map { |line| line.start_with?("      ") ? line[4..] : line }.join
        content = content.sub(/^  include RetroUI::ClassNames\n\n/, "")
        content.sub(/\nend\n\z/, "\n#{vendored_class_names_helper}\nend\n")
      end

      def vendored_class_names_helper
        <<~RUBY
            private

            # Small class-list helper copied with vendored components.
            # It does not implement Tailwind-aware conflict resolution.
            def class_names(*values)
              values.flatten.compact.reject { |value| value == false }.map(&:to_s).reject(&:empty?).join(" ")
            end
        RUBY
      end

      def gem_root
        Pathname.new(File.expand_path("../../../..", __dir__))
      end

      def destination_path
        Pathname.new(destination_root)
      end

      def relative_to_destination(path)
        path.relative_path_from(destination_path).to_s
      end
    end
  end
end
