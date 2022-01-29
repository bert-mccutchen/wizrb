# frozen_string_literal: true

RSpec.describe Wizrb::Shared::Discover do
  # rubocop:disable RSpec/EmptyExampleGroup
  xdescribe '#all' do
    # TODO
  end
  # rubocop:enable RSpec/EmptyExampleGroup

  describe '#home' do
    let(:discoverer) { described_class.new }

    before do
      allow(discoverer).to receive(:all)
      discoverer.home(1234)
    end

    it 'calls #all with the homeId filter' do
      expect(discoverer).to have_received(:all).with(filters: { 'homeId' => 1234 }).once
    end
  end

  describe '#room' do
    let(:discoverer) { described_class.new }

    before do
      allow(discoverer).to receive(:all)
      discoverer.room(5678)
    end

    it 'calls #all with the roomId filter' do
      expect(discoverer).to have_received(:all).with(filters: { 'roomId' => 5678 }).once
    end
  end
end
