# frozen_string_literal: true

require "rails/engine"
require "view_component"

module RetroUI
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace RetroUI::Rails

      config.autoload_paths << root.join("app/components").to_s
      config.eager_load_paths << root.join("app/components").to_s

      initializer "retroui_rails.assets" do |app|
        app.config.assets.precompile += %w[retro_ui/rails/theme.css] if app.config.respond_to?(:assets)
      end
    end
  end
end
