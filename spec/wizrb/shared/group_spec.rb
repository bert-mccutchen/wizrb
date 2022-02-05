# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Group do
  let(:device1) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:device2) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:group) { described_class.new(devices: [device1, device2]) }

  describe '#power_on' do
    let(:power_event) { Wizrb::Shared::Events::PowerEvent }

    before { group.power_on }

    it 'dispatches the event to device1' do
      expect(device1).to have_received(:dispatch_event).with(an_instance_of(power_event)).once
    end

    it 'dispatches the event to device2' do
      expect(device2).to have_received(:dispatch_event).with(an_instance_of(power_event)).once
    end
  end

  describe '#power_off' do
    let(:power_event) { Wizrb::Shared::Events::PowerEvent }

    before { group.power_off }

    it 'dispatches the event to device1' do
      expect(device1).to have_received(:dispatch_event).with(an_instance_of(power_event)).once
    end

    it 'dispatches the event to device2' do
      expect(device2).to have_received(:dispatch_event).with(an_instance_of(power_event)).once
    end
  end

  describe '#reboot' do
    let(:reboot_event) { Wizrb::Shared::Events::RebootEvent }

    before { group.reboot }

    it 'dispatches the event to device1' do
      expect(device1).to have_received(:dispatch_event).with(an_instance_of(reboot_event)).once
    end

    it 'dispatches the event to device2' do
      expect(device2).to have_received(:dispatch_event).with(an_instance_of(reboot_event)).once
    end
  end

  describe '#reset' do
    let(:reset_event) { Wizrb::Shared::Events::ResetEvent }

    before { group.reset }

    it 'dispatches the event to device1' do
      expect(device1).to have_received(:dispatch_event).with(an_instance_of(reset_event)).once
    end

    it 'dispatches the event to device2' do
      expect(device2).to have_received(:dispatch_event).with(an_instance_of(reset_event)).once
    end
  end

  describe '#dispatch_event' do
    let(:new_event) { Wizrb::Shared::Events::Base.new(method: 'setState', params: { a: 1 }) }

    describe 'with valid event' do
      before { group.dispatch_event(new_event) }

      it 'dispatches the event to device1' do
        expect(device1).to have_received(:dispatch_event).with(new_event).once
      end

      it 'dispatches the event to device2' do
        expect(device2).to have_received(:dispatch_event).with(new_event).once
      end
    end

    context 'with invalid event' do
      let(:new_event) { Object.new }

      it 'raises an error' do
        expect { group.dispatch_event(new_event) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '#dispatch_events' do
    let(:new_event1) { Wizrb::Shared::Events::Base.new(method: 'setState', params: { a: 1 }) }
    let(:new_event2) { Wizrb::Shared::Events::Base.new(method: 'setState', params: { a: 0, b: 1 }) }

    context 'with valid events' do
      before { group.dispatch_events(new_event1, new_event2) }

      it 'dispatches the event to device1' do
        expect(device1).to have_received(:dispatch_event).with(an_instance_of(Wizrb::Shared::Events::Base)).once
      end

      it 'dispatches the event to device2' do
        expect(device2).to have_received(:dispatch_event).with(an_instance_of(Wizrb::Shared::Events::Base)).once
      end
    end

    context 'with invalid events' do
      let(:new_event2) { Object.new }

      it 'raises an error' do
        expect { group.dispatch_events(new_event1, new_event2) }.to raise_error(ArgumentError)
      end
    end
  end
end
