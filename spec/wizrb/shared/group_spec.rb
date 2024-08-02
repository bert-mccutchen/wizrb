# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Group do
  let(:foo_device) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:bar_device) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:group) { described_class.new(devices: [foo_device, bar_device]) }

  describe "#power_on" do
    it_behaves_like "a group event", Wizrb::Shared::Events::PowerEvent, :power_on
  end

  describe "#power_off" do
    it_behaves_like "a group event", Wizrb::Shared::Events::PowerEvent, :power_off
  end

  describe "#reboot" do
    it_behaves_like "a group event", Wizrb::Shared::Events::RebootEvent, :reboot
  end

  describe "#reset" do
    it_behaves_like "a group event", Wizrb::Shared::Events::ResetEvent, :reset
  end

  describe "#dispatch_event" do
    let(:new_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 1}) }

    describe "with valid event" do
      before { group.dispatch_event(new_event) }

      it "dispatches the event to foo_device" do
        expect(foo_device).to have_received(:dispatch_event).with(new_event).once
      end

      it "dispatches the event to bar_device" do
        expect(bar_device).to have_received(:dispatch_event).with(new_event).once
      end
    end

    context "with invalid event" do
      let(:new_event) { Object.new }

      it "raises an error" do
        expect { group.dispatch_event(new_event) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#dispatch_events" do
    let(:new_foo_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 1}) }
    let(:new_bar_event) { Wizrb::Shared::Events::Base.new(method: "setState", params: {a: 0, b: 1}) }

    context "with valid events" do
      before { group.dispatch_events(new_foo_event, new_bar_event) }

      it "dispatches the event to foo_device" do
        expect(foo_device).to have_received(:dispatch_event).with(an_instance_of(Wizrb::Shared::Events::Base)).once
      end

      it "dispatches the event to bar_device" do
        expect(bar_device).to have_received(:dispatch_event).with(an_instance_of(Wizrb::Shared::Events::Base)).once
      end
    end

    context "with invalid events" do
      let(:new_bar_event) { Object.new }

      it "raises an error" do
        expect { group.dispatch_events(new_foo_event, new_bar_event) }.to raise_error(ArgumentError)
      end
    end
  end
end
