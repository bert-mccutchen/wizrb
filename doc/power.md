# Wizrb Power Devices

Power devices do not extend beyond the features of standard Wizrb Devices. For more information refer to the [Wizrb Devices](devices.md) documentation.

* [Connecting To Power Devices](#connecting-to-power-devices)
  * [Individual Power Devices](#individual-power-devices)
  * [Finding Power Devices](#finding-power-devices)
* [Interacting With Power Devices](#interacting-with-power-devices)

## Connecting To Power Devices

#### Individual Power Devices
```ruby
# Connect to plug @ 127.0.0.1
plug = Wizrb::Power::Products::SmartPlug.new(ip: '127.0.0.1')

# Connect to plug @ 127.0.0.1:38899
plug = Wizrb::Power::Products::SmartPlug.new(ip: '127.0.0.1', port: 38899)
```

#### Finding Power Devices
```ruby
# Finding all devices:
group = Wizrb::Power::Discover.all
# => Wizrb::Power::Group

# Finding all devices in home by ID:
group = Wizrb::Power::Discover.home(1234)
# => Wizrb::Power::Group

# Finding all devices in room by ID:
group = Wizrb::Power::Discover.room(1234)
# => Wizrb::Power::Group
```

## Interacting With Power Devices
Rrefer to ["Interacting With Devices"](devices.md#interacting-with-devices) in the Wizrb Devices documentation.
