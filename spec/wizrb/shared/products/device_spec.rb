# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Products::Device do
  let(:device) { described_class.new(ip: "127.0.0.1") }

  # rubocop:disable RSpec/AnyInstance
  before { allow_any_instance_of(described_class).to receive(:connect) }
  # rubocop:enable RSpec/AnyInstance

  describe "#system_config" do
    subject { device.system_config }

    let(:response) { JSON.parse(File.read("spec/fixtures/getSystemConfig.json")) }

    before { allow(device).to receive(:dispatch).and_return(response) }

    it { is_expected.to eq(response["result"]) }
  end

  describe "#model_config" do
    subject { device.model_config }

    let(:response) { JSON.parse(File.read("spec/fixtures/getModelConfig.json")) }

    before { allow(device).to receive(:dispatch).and_return(response) }

    it { is_expected.to eq(response["result"]) }
  end

  describe "#user_config" do
    subject { device.user_config }

    let(:response) { JSON.parse(File.read("spec/fixtures/getUserConfig.json")) }

    before { allow(device).to receive(:dispatch).and_return(response) }

    it { is_expected.to eq(response["result"]) }
  end

  describe "#module_name" do
    subject { device.module_name }

    let(:response) { JSON.parse(File.read("spec/fixtures/getSystemConfig.json")) }

    before { allow(device).to receive(:dispatch).and_return(response) }

    it { is_expected.to eq(response["result"]["moduleName"]) }
  end

  describe "#power_on" do
    let(:power_event) { Wizrb::Shared::Events::PowerEvent }

    before do
      allow(device).to receive(:dispatch)
      device.power_on
    end

    it "dispatches the power event" do
      expect(device).to have_received(:dispatch).with(an_instance_of(power_event)).once
    end
  end

  describe "#power_off" do
    let(:power_event) { Wizrb::Shared::Events::PowerEvent }

    before do
      allow(device).to receive(:dispatch)
      device.power_off
    end

    it "dispatches the power event" do
      expect(device).to have_received(:dispatch).with(an_instance_of(power_event)).once
    end
  end

  describe "#power_switch" do
    before do
      allow(device).to receive(:dispatch).and_return(response)
      allow(device).to receive(:power_on)
      allow(device).to receive(:power_off)
      device.power_switch
    end

    context "when device is off" do
      let(:response) { JSON.parse(File.read("spec/fixtures/getPilot_off.json")) }

      it "powers on the device" do
        expect(device).to have_received(:power_on).once
      end
    end

    context "when device is on" do
      let(:response) { JSON.parse(File.read("spec/fixtures/getPilot_on.json")) }

      it "powers off the device" do
        expect(device).to have_received(:power_off).once
      end
    end
  end

  describe "#reboot" do
    let(:reboot_event) { Wizrb::Shared::Events::RebootEvent }

    before do
      allow(device).to receive(:dispatch)
      device.reboot
    end

    it "dispatches the reboot event" do
      expect(device).to have_received(:dispatch).with(an_instance_of(reboot_event)).once
    end
  end

  describe "#reset" do
    let(:reset_event) { Wizrb::Shared::Events::ResetEvent }

    before do
      allow(device).to receive(:dispatch)
      device.reset
    end

    it "dispatches the reset event" do
      expect(device).to have_received(:dispatch).with(an_instance_of(reset_event)).once
    end
  end

  describe "#refresh" do
    let(:refresh_event) { Wizrb::Shared::Events::RefreshEvent }
    let(:response) { JSON.parse(File.read("spec/fixtures/getPilot_on.json")) }

    before do
      allow(device).to receive(:dispatch).and_return(response)
      device.refresh
    end

    it "dispatches the refresh event" do
      expect(device).to have_received(:dispatch).with(an_instance_of(refresh_event)).once
    end

    it "updates the power state" do
      expect(device.state.power).to be(true)
    end
  end

  describe "#dispatch_event" do
    before { allow(device).to receive(:dispatch) }

    context "with valid event" do
      let(:new_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 1}) }

      it "dispatches the event" do
        device.dispatch_event(new_event)
        expect(device).to have_received(:dispatch).with(new_event).once
      end
    end

    context "with invalid event" do
      let(:new_event) { Object.new }

      it "raises an error" do
        expect { device.dispatch_event(new_event) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#dispatch_events" do
    let(:new_foo_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 1}) }
    let(:new_bar_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 0, b: 1}) }

    before { allow(device).to receive(:dispatch) }

    context "with valid event" do
      it "dispatches the event" do
        device.dispatch_events(new_foo_event, new_bar_event)
        expect(device).to have_received(:dispatch).with(an_instance_of(Wizrb::Shared::Events::Base)).once
      end
    end

    context "with invalid event" do
      let(:new_bar_event) { Object.new }

      it "raises an error" do
        expect { device.dispatch_events(new_foo_event, new_bar_event) }.to raise_error(ArgumentError)
      end
    end
  end
end
