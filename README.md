# Wizrb

***Pronounced like "Wizard"***

This is a hobby project for getting the most out of Philips WiZ devices. Currently this project only supports Philips WiZ lights and plugs. If you would like to support this project, donations to buy new types of Philips WiZ accessories or coffee will be much appreciated!

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/M4M76DVZR)

#### Compatability Notice

Compatability may vary since I only own [Philips WiZ Bulb A19 E26 (Full Color)](https://www.wizconnected.com/en-CA/consumer/products/046677556136/) bulbs and a [LED Strip Starter kit 2m (Full Color)](https://www.wizconnected.com/en-CA/consumer/products/046677560805/) to test with.

Testers with other (supported) Philips WiZ devices are welcome!

#### Tested Devices:

* [Bulb A19 E26 (Full Color)](https://www.wizconnected.com/en-CA/consumer/products/046677556136/)
* [Filament amber ST64 E27 (Dimmable)](https://www.wizconnected.com/en/consumer/products/8718699787332/)
* [LED Strip Starter kit 2m (Full Color)](https://www.wizconnected.com/en-CA/consumer/products/046677560805/)
* [Smart Plug (Type B)](https://www.wizconnected.com/en-CA/consumer/products/046677603090/)

## Installation

Install via Bundler:
```bash
bundle add wizrb
```

Or install it manually:
```bash
gem install wizrb
```
## Usage

Most of the documentation on how to use this gem is located within [Wizrb Devices](doc/devices.md).

Documentation for specific device types:
* [Lighting Devices](doc/lighting.md)
* [Power Devices](doc/power.md)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bert-mccutchen/wizrb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/bert-mccutchen/wizrb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Wizrb project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bert-mccutchen/wizrb/blob/master/CODE_OF_CONDUCT.md).
