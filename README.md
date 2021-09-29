# Wizrb

***Pronounced like "Wizard"***

This is a hobby project for getting the most out of Philips WiZ devices. Currently this project only supports Philips WiZ light bulbs. If you would like to support this project, donations to buy new types of Philips WiZ accessories or coffee will be much appreciated!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

#### Compatability Notice

Compatability may vary since I only own [Philips WiZ Bulb A19 E26 (Full color)](https://www.wizconnected.com/en-CA/consumer/products/046677556136/) bulbs to test with.

Testers with other (supported) Philips WiZ devices are welcome!

#### Tested Devices:
* [ ] Bulb A19 E26 (Dimmable)
* [ ] Bulb A19 E26 (Tunable white)
* [x] Bulb A19 E26 (Full color)
* [ ] Bulb A21 E26 (Full color)
* [ ] Candle B12 E12 (Full color)
* [ ] Filament amber A19 E26 (Dimmable)
* [ ] Filament amber G25 E26 (Dimmable)
* [ ] Filament amber ST19 E26 (Dimmable)
* [ ] Filament clear A19 E26 (Dimmable)
* [ ] Filament clear G25 E26 (Dimmable)
* [ ] Filament clear ST19 E26 (Dimmable)
* [ ] Reflector BR30 E26 (Dimmable)
* [ ] Reflector BR30 E26 (Tunable white)
* [ ] Reflector BR30 E26 (Full color)
* [ ] Spot PAR38 E26 (Tunable white)
* [ ] Spot PAR16 GU10 (Full color)
* [ ] LED Strip Starter kit 2m (Full color)
* [ ] LED Strip Extension 1m (Full color)
* [ ] Recessed downlight 6" E26 (Tunable white)
* [ ] Recessed downlight 6" E26 (Full color)
* [ ] Portable (Full color)

#### Unsupported Devices:
* [x] Smart Plug (Type B)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wizrb'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wizrb

## Usage

### Connecting to Individual Lights
```ruby
# Connect to light @ 127.0.0.1
bulb = Wizrb::Lighting::Products::Bulb.new(ip: '127.0.0.1')

# Connect to light @ 127.0.0.1:38899
bulb = Wizrb::Lighting::Products::Bulb.new(ip: '127.0.0.1', port: 38899)
```

### Finding Lights
```ruby
# Finding all lights:
group = Wizrb::Lighting::Discover.new.all
# => Wizrb::Lighting::Group

# Finding all lights in home by ID:
group = Wizrb::Lighting::Discover.new.home(1234)
# => Wizrb::Lighting::Group

# Finding all lights in room by ID:
group = Wizrb::Lighting::Discover.new.room(1234)
# => Wizrb::Lighting::Group
```

### Interacting with Lights

#### Simple On/Off/Switch
```ruby
bulb = Wizrb::Lighting::Products::Bulb.new(ip: '127.0.0.1')

bulb.power_on
bulb.power_off
bulb.power_switch
```

#### Fetching Bulb State
```ruby
bulb = Wizrb::Lighting::Products::Bulb.new(ip: '127.0.0.1')

bulb.state
# => Wizrb::Lighting::State

bulb.state.power
# => true

bulb.state.cold_white
# => 255

bulb.state.color_temp
# => 3200

bulb.state.brightness
# => 255

bulb.state.rgb
# => { red: 255, green: 255, blue: 255 }

bulb.state.scene
# => :party

bulb.state.speed
# => 200

bulb.state.warm_white
# => 255
```

#### Dispatching Single Lighting Events
```ruby
# Turn on all lights.
event = Wizrb::Lighting::Events::PowerEvent.new(true)
group.dispatch_event(event)

# Turn off the first light.
event = Wizrb::Lighting::Events::PowerEvent.new(false)
group.bulbs.first.dispatch_event(event)
```

#### Dispatching Multiple Lighting Events
Events are merged when dispatching multiples to reduce chatter.

```ruby
# Turn on all lights to party at full speed.
group.dispatch_events(
  Wizrb::Lighting::Events::PowerEvent.new(true),
  Wizrb::Lighting::Events::SetSceneEvent.new(:party),
  Wizrb::Lighting::Events::SetSpeedEvent.new(200)
)

# Tell the last light to relax.
group.bulbs.last.dispatch_events(
  Wizrb::Lighting::Events::SetSceneEvent.new(:relax),
  Wizrb::Lighting::Events::SetSpeedEvent.new(10)
)
```

#### Available Lighting Events
```ruby
# Boolean ON - OFF
Wizrb::Lighting::Events::PowerEvent.new(true)

# No arguments
Wizrb::Lighting::Events::RebootEvent.new

# No arguments
Wizrb::Lighting::Events::RefreshEvent.new

# No arguments
Wizrb::Lighting::Events::ResetEvent.new

# Integer 10 - 255
Wizrb::Lighting::Events::SetBrightnessEvent.new(255)

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

#### Creating Custom Scenes
You can create custom scenes that inherit from `Wizrb::Lighting::Scenes::Scene`.
```ruby
# frozen_string_literal: true

class BurglarScene < Wizrb::Lighting::Scenes::Scene
  RED_STATE_EVENTS = [
    Wizrb::Lighting::Events::PowerEvent.new(true),
    Wizrb::Lighting::Events::SetBrightnessEvent.new(100),
    Wizrb::Lighting::Events::SetRgbEvent.new(255, 0, 0)
  ].freeze

  BLUE_STATE_EVENTS = [
    Wizrb::Lighting::Events::PowerEvent.new(true),
    Wizrb::Lighting::Events::SetBrightnessEvent.new(100),
    Wizrb::Lighting::Events::SetRgbEvent.new(0, 0, 255)
  ].freeze

  def initialize(group)
    super(group)
    @toggle = true
  end

  protected

  def before_start
    # Do something before your scene starts.
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

  def after_stop
    # Do something after your scene stops.
  end
end
```

#### Using Custom Scenes
```ruby
group = Wizrb::Lighting::Discover.new.all
scene = BurglarScene.new(group)

# Start the scene.
scene.start

# Stop the scene.
scene.stop
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/wizrb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bert-mccutchen/wizrb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Wizrb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bert-mccutchen/wizrb/blob/master/CODE_OF_CONDUCT.md).
