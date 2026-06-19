# frozen_string_literal: true

require "spec_helper"
require "generators/retro_ui/vendor/vendor_generator"
require "securerandom"

RSpec.describe RetroUI::Generators::VendorGenerator, type: :generator do
  tests RetroUI::Generators::VendorGenerator

  destination File.expand_path("../../tmp/vendor_generator", __dir__)

  before do
    self.class.destination File.expand_path("../../tmp/vendor_generator_#{SecureRandom.hex(8)}", __dir__)
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)
  end

  it "copies expected files" do
    run_generator

    expect(destination_file("app/components/retro_ui/button_component.rb")).to exist
    expect(destination_file("app/components/retro_ui/button_component.html.erb")).to exist
    expect(destination_file("app/components/retro_ui/card_component.rb")).to exist
    expect(destination_file("app/assets/stylesheets/retro_ui/theme.css")).to exist
  end

  it "rewrites namespaces from RetroUI::Rails to RetroUI" do
    run_generator

    content = destination_file("app/components/retro_ui/button_component.rb").read
    expect(content).to include("RetroUI::ButtonComponent")
    expect(content).not_to include("RetroUI::Rails::ButtonComponent")
    expect(content).not_to include("module Rails")
    expect(content).not_to include("RetroUI::ClassNames")
    expect(content).to include("def class_names(*values)")
  end

  it "does not overwrite without --force" do
    run_generator
    original = destination_file("app/components/retro_ui/button_component.rb").read

    run_generator
    expect(destination_file("app/components/retro_ui/button_component.rb").read).to eq(original)
  end

  def destination_file(path)
    Pathname.new(destination_root).join(path)
  end
end
