# frozen_string_literal: true

require "rails/generators"

module RetroUI
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      desc "Print RetroUI Rails installation instructions."

      def print_tailwind_instructions
        say "RetroUI Rails requires Tailwind CSS. There is no Tailwind-free fallback.", :yellow
        say ""
        say "Add the RetroUI theme tokens to your compiled stylesheet:"
        say '  @import "retro_ui/rails/theme.css";'
        say ""
        say "Ensure Tailwind scans the classes used by RetroUI components:"
        say "  - app/components/**/*.rb"
        say "  - app/components/**/*.erb"
        say "  - #{gem_component_glob}"
        say "  - app/components/retro_ui/**/*.rb"
        say "  - app/components/retro_ui/**/*.erb"
        say ""
        say "If your Tailwind setup cannot scan gem files, run:"
        say "  rails generate retro_ui:vendor"
        say ""
        say "Vendored components are app-owned and should be included by the app/components globs above."
        say ""
        say "Hotwire components require Stimulus. Register the toast controller with your Stimulus application:"
        say '  pin "retro_ui/rails/controllers/toast_controller", to: "retro_ui/rails/controllers/toast_controller.js"'
        say '  import ToastController from "retro_ui/rails/controllers/toast_controller"'
        say '  application.register("retro-ui--toast", ToastController)'
        say ""
        say "When vendored, copy or register app/javascript/controllers/retro_ui/toast_controller.js instead."
      end

      private

      def gem_component_glob
        File.expand_path("../../../../app/components/retro_ui/rails/**/*.{rb,erb}", __dir__)
      end
    end
  end
end
