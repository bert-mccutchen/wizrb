# frozen_string_literal: true

require 'thor'
require 'wizrb'

module Wizrb
  class CLI < Thor
    include Thor::Actions

    package_name 'Wizrb'

    desc 'scene [SCENE]', 'Start a scene on all lights'
    method_option :scene, aliases: '-s', type: :string, required: true
    def scene
      scene_type = load_scene
      return unless scene_type

      group = find_lights
      return unless group

      scene = scene_type.new(group)
      start(scene)
      prompt_stop
      stop(scene)
    end

    private

    def scene_class(string)
      name = string.split('_').map(&:capitalize).join
      Object.const_get("Wizrb::Lighting::Scenes::#{name}Scene")
    rescue NameError
      nil
    end

    def load_scene
      say('Loading scene...  ')
      scene_type = scene_class(options[:scene])

      if scene_type
        say('DONE', :green)
      else
        say('INVALID SCENE', :red)
      end

      scene_type
    end

    def find_lights
      say('Finding lights... ')
      group = Wizrb::Lighting::Discover.new(wait: 10).all

      if group.bulbs.count == 0
        say('NONE FOUND', :red)
        return nil
      else
        say("#{group.bulbs.count} FOUND", :green)
      end

      group
    end

    def start(scene)
      say('Starting scene... ')
      scene.start
      say('DONE', :green)
    end

    def prompt_stop
      nil until yes?('Would you like to stop? [y, yes]')
    end

    def stop(scene)
      say('Stopping scene... ')
      scene.stop
      say('DONE', :green)
    end
  end
end
