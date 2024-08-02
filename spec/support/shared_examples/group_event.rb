# frozen_string_literal: true

RSpec.shared_examples "a group event" do |klass, method, *values|
  before { group.send(method, *values) }

  it "dispatches the event to foo_device" do
    expect(foo_device).to have_received(:dispatch_event).with(an_instance_of(klass)).once
  end

  it "dispatches the event to bar_device" do
    expect(bar_device).to have_received(:dispatch_event).with(an_instance_of(klass)).once
  end
end
