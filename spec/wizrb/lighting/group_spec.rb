# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::Group do
  let(:foo_device) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:bar_device) { instance_spy(Wizrb::Shared::Products::Device) }
  let(:group) { described_class.new(devices: [foo_device, bar_device]) }

  it 'is an instance of Wizrb::Shared::Group' do
    expect(group).to be_a(Wizrb::Shared::Group)
  end

  describe '#brightness' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetBrightnessEvent, :brightness, 50
  end

  describe '#cold_white' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetColdWhiteEvent, :cold_white, 50
  end

  describe '#color_temp' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetColorTempEvent, :color_temp, 3200
  end

  describe '#rgb' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetRgbEvent, :rgb, 32, 64, 128
  end

  describe '#speed' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetSpeedEvent, :speed, 50
  end

  describe '#warm_white' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetWarmWhiteEvent, :warm_white, 50
  end

  describe '#scene' do
    it_behaves_like 'a group event', Wizrb::Lighting::Events::SetSceneEvent, :scene, :party
  end
end
