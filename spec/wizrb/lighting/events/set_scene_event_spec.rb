# frozen_string_literal: true

RSpec.describe Wizrb::Lighting::Events::SetSceneEvent do
  subject(:event) { described_class.new(value) }

  Wizrb::Lighting::SCENES.each_key do |scene|
    context "with #{scene} scene" do
      let(:value) { scene }

      it 'does not raise an error' do
        expect { event }.not_to raise_error
      end

      it 'sets the sceneId param' do
        expect(event.params).to eq({ sceneId: Wizrb::Lighting::SCENES[value] })
      end
    end
  end

  context 'with invalid scene' do
    let(:value) { :invalid }

    it 'does raise an error' do
      expect { event }.to raise_error(ArgumentError)
    end
  end
end
