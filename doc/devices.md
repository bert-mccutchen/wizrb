# Wizrb Devices

All devices inherit from a single class `Wizrb::Shared::Devices`. These device classes contain features that are shared among the Phillips WiZ device lineup.

* [Connecting To Devices](#connecting-to-devices)
  * [Individual Devices](#individual-devices)
  * [Finding Devices](#finding-devices)
* [Interacting With Devices](#interacting-with-devices)
  * [Reading State](#reading-state)
  * [Power Control](#power-control)
  * [Information / Administration](#information--administration)
* [Manually Dispatching Events](#manually-dispatching-events)
  * [Individual Devices](#individual-devices)
  * [Device Groups](#device-groups)
  * [Dispatching Multiple Events](#dispatching-multiple-events)
  * [Available Device Events](#available-device-events)

## Connecting To Devices

#### Individual Devices
```ruby
# Connect to device @ 127.0.0.1
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1')

# Connect to device @ 127.0.0.1:38899
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1', port: 38899)
```

#### Finding Devices
```ruby
# Finding all devices:
group = Wizrb::Shared::Discover.all
# => Wizrb::Shared::Group

# Finding all devices in home by ID:
group = Wizrb::Shared::Discover.home(1234)
# => Wizrb::Shared::Group

# Finding all devices in room by ID:
group = Wizrb::Shared::Discover.room(1234)
# => Wizrb::Shared::Group
```

## Interacting With Devices

#### Reading State
```ruby
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1')

device.state
# => Wizrb::Shared::State

device.state.power
# => true
```

#### Power Control
```ruby
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1')

device.power_on
device.power_off
device.power_switch
```

#### Information / Administration
```ruby
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1')

device.system_config
device.model_config
device.user_config
device.module_name

device.reboot # Reboots the device.
device.reset # Factory resets the device.
device.refresh # Refreshes known device state.
```

## Manually Dispatching Events

#### Individual Devices
```ruby
device = Wizrb::Shared::Products::Device.new(ip: '127.0.0.1')

# Turn the device on.
device.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))

# Turn the device off.
device.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(false))
```

#### Device Groups
```ruby
group = Wizrb::Shared::Discover.all

# Turn on all devices.
group.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))

# Turn off all devices.
group.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(false))

# Turn on half of the devices.
# Groups implement Enumerable to iterate over the devices within.
group.each_with_index.each do |device, index|
  next unless index % 2 == 0
  device.dispatch_event(Wizrb::Shared::Events::PowerEvent.new(true))
end
```

#### Dispatching Multiple Events
Events are merged when dispatching multiples to reduce chatter.

```ruby
# Notice the pluralization of dispatch_event.
group.dispatch_events(
  Wizrb::Shared::Events::PowerEvent.new(true),
  Wizrb::Shared::Events::RebootEvent.new
)
```

#### Available Device Events
```ruby
# Boolean ON - OFF
Wizrb::Shared::Events::PowerEvent.new(true)

# No arguments
Wizrb::Shared::Events::RebootEvent.new

# No arguments
Wizrb::Shared::Events::RefreshEvent.new

# No arguments
Wizrb::Shared::Events::ResetEvent.new
```
