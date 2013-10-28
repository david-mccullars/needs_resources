require 'singleton'
require 'yaml'

module NeedsResources
  class TopLevelResources

    include Singleton
    include ResourceContainer

    private

    def resources
      @resources ||= parse(resource_config_file)
    end

    def resource_config_file
      Dir[ENV['RESOURCES'].to_s, File.expand_path('~/.resources'), '.resources'].first
    end

    def parse(file)
      return {} unless File.exist? file

      yaml = YAML.load_file(file)
      raise InvalidOrCorruptedResources unless yaml.is_a? Hash

      parse_resources(yaml)
    end

    def parse_resources(hash)
      resources = {}

      hash.each do |name, value|
        prefix, type = parse_resource_name(name)
        resources[name.to_sym] = parse_resource_value(name, type, value)

        # Make sure both default_xyz and xyz are aliases
        if prefix == 'default_'
          resources[type.to_sym] ||= name.to_sym
        elsif prefix.nil?
          resources[type.to_sym] ||= "default_#{type}".to_sym
        end
      end

      # Copy symbol aliases
      resources.each do |name, value|
        resources[name] = dereference_alias(resources, name, value) or raise InvalidResourceAliasError.new(value)
      end

      resources
    end

    def top_level_names
      ResourceType.children.keys
    end

    def parse_resource_name(name)
      if m = /^(.*_)?(#{top_level_names * '|'})$/.match(name)
        m[1..2]
      else
        raise InvalidResourceKeyError.new(name)
      end
    end

    def parse_resource_value(name, type, value)
      case value
      when Symbol, String, Fixnum
        value
      when Hash
        if value.has_key?("resources")
          raise InvalidResourceValueError.new(name, value) unless value.is_a? Hash
          value["resources"] = parse_resources value["resources"]
        end
        ResourceType.children[type].new(value.merge :name => name)
      else
        raise InvalidResourceValueError.new(name, value)
      end
    end

    def dereference_alias(hash, name, value)
      considered = Set.new
      while value.is_a?(Symbol) and !considered.include?(value)
        considered << name
        name = value
        value = hash[value]
      end
      value
    end

    def to_s
      "Top Level Resources"
    end

  end
end
