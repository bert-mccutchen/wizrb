# Wizrb Lighting Devices

Lighting devices build onto the standard Wizrb Device feature set, providing the capability to create elaborate lighting setups.

* [Connecting To Lighting Devices](#connecting-to-lighting-devices)
  * [Individual Lighting Devices](#individual-lighting-devices)
  * [Finding Lighting Devices](#finding-lighting-devices)
* [Interacting With Lighting Devices](#interacting-with-lighting-devices)
  * [Reading State](#reading-state)
  * [Lighting State Control](#lighting-state-control)
  * [Available Lighting Events](#available-lighting-events)
* [Scenes](#scenes)
  * [Creating Custom Scenes](#creating-custom-scenes)
  * [Using Custom Scenes](#using-custom-scenes)

## Connecting To Lighting Devices

#### Individual Lighting Devices
```ruby
# Connect to light @ 127.0.0.1
light = Wizrb::Lighting::Products::Light.new(ip: '127.0.0.1')

# Connect to light @ 127.0.0.1:38899
light = Wizrb::Lighting::Products::Light.new(ip: '127.0.0.1', port: 38899)
```

#### Finding Lighting Devices
```ruby
# Finding all devices:
group = Wizrb::Lighting::Discover.all
# => Wizrb::Lighting::Group

# Finding all devices in home by ID:
group = Wizrb::Lighting::Discover.home(1234)
# => Wizrb::Lighting::Group

# Finding all devices in room by ID:
group = Wizrb::Lighting::Discover.room(1234)
# => Wizrb::Lighting::Group
```

## Interacting With Lighting Devices
Rrefer to ["Interacting With Devices"](devices.md#interacting-with-devices) in the Wizrb Devices documentation for the standard set of device interactions.

#### Reading State
```ruby
light = Wizrb::Lighting::Products::Light.new(ip: '127.0.0.1')

light.state
# => Wizrb::Lighting::State

light.state.power
# => true

light.state.cold_white
# => 255

light.state.color_temp
# => 3200

light.state.brightness
# => 100

light.state.rgb
# => { red: 255, green: 255, blue: 255 }

light.state.scene
# => :party

light.state.speed
# => 200

light.state.warm_white
# => 255
```

#### Lighting State Control
```ruby
light = Wizrb::Lighting::Products::Light.new(ip: '127.0.0.1')

# Integer 10 - 100
light.brightness(100)

# Integer 1 - 255
light.cold_white(255)

# Integer 1000 - 10000 in increments of 100
light.color_temp(3200)

# Integers 0 - 255
light.rgb(255, 255, 255)

# Any key in Wizrb::Lighting::SCENES
light.scene(:party)

# Integer 10 - 200
light.speed(200)

# Integer 1 - 255
light.warm_white(255)
```

#### Available Lighting Events
```ruby
# Integer 10 - 100
Wizrb::Lighting::Events::SetBrightnessEvent.new(100)

# Integer 1 - 255
Wizrb::Lighting::Events::SetColdWhiteEvent.new(255)

# Integer 1000 - 10000 in increments of 100
Wizrb::Lighting::Events::SetColorTempEvent.new(3200)

# Integers 0 - 255
Wizrb::Lighting::Events::SetRgbEvent.new(255, 255, 255)

# Any key in Wizrb::Lighting::SCENES
Wizrb::Lighting::Events::SetSceneEvent.new(:party)

# Integer 10 - 200
Wizrb::Lighting::Events::SetSpeedEvent.new(200)

# Integer 1 - 255
Wizrb::Lighting::Events::SetWarmWhiteEvent.new(255)
```

## Scenes

#### Creating Custom Scenes
You can create custom scenes that inherit from `Wizrb::Lighting::Scenes::Scene`.
```ruby
# frozen_string_literal: true

class BurglarScene < Wizrb::Lighting::Scenes::Scene
  RED_STATE_EVENTS = [
    Wizrb::Lighting::Events::SetBrightnessEvent.new(100),
    Wizrb::Lighting::Events::SetRgbEvent.new(255, 0, 0)
  ].freeze

  BLUE_STATE_EVENTS = [
    Wizrb::Lighting::Events::SetBrightnessEvent.new(100),
    Wizrb::Lighting::Events::SetRgbEvent.new(0, 0, 255)
  ].freeze

  def initialize(group)
    super(group)
    @toggle = true
  end

  protected

  # Do something before your scene starts.
  def before_start
     @group.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))
  end

  # Called on loop until scene stopped.
  def step
    if @toggle
      @group.dispatch_events(*RED_STATE_EVENTS)
    else
      @group.dispatch_events(*BLUE_STATE_EVENTS)
    end

    @toggle = !@toggle
    sleep(1)
  end

  # Do something after your scene stops.
  def after_stop
    @group.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(false))
  end
end
```

#### Using Custom Scenes
```ruby
group = Wizrb::Lighting::Discover.all
scene = BurglarScene.new(group)

# Start the scene.
scene.start

# Stop the scene.
scene.stop
```
