# frozen_string_literal: true

require "spec_helper"
require "generators/retro_ui/install/install_generator"
require "securerandom"

RSpec.describe RetroUI::Generators::InstallGenerator, type: :generator do
  tests RetroUI::Generators::InstallGenerator

  destination File.expand_path("../../tmp/install_generator", __dir__)

  before do
    self.class.destination File.expand_path("../../tmp/install_generator_#{SecureRandom.hex(8)}", __dir__)
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)
  end

  it "prints Tailwind setup instructions" do
    messages = []
    generator = described_class.new
    allow(generator).to receive(:say) { |message = "", *_args| messages << message.to_s }
    generator.print_tailwind_instructions
    output = messages.join("\n")

    expect(output).to include("RetroUI Rails requires Tailwind CSS")
    expect(output).to include('@import "retro_ui/rails/theme.css";')
    expect(output).to include("Ensure Tailwind scans")
    expect(output).to include("rails generate retro_ui:vendor")
  end
end
