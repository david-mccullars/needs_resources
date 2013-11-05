module NeedsResources
  module ResourceContainer

    def [](name)
      resources[name.to_sym] or raise MissingResourceError.new(child_resource_name name)
    end

    def []=(name, hash)
      resources.merge! TopLevelResources.instance.send(:parse_resources, name.to_sym => hash)
    end

    def has_resource?(name)
      resources.has_key? name.to_sym
    end

    def child_resource_name(child_name)
      if respond_to?(:name)
        "#{self.name}.#{child_name}"
      else
        child_name.to_s
      end
    end

    def resources
      @resources ||= {}
    end

    def resources_needed
      @resources_needed ||= Set.new
    end

    def resources_hash
      hash = {}
      resources.sort_by { |k, v| "#{v.class}___#{k}" }.each do |k, v|
        next if k.to_s.starts_with? 'default_'
        hash[k.to_s] = v.respond_to?(:to_hash) ? v.to_hash : v
      end
      hash
    end

    def missing_resources
      __missing_resources__(missing = {})
      missing.map do |k, v|
        k.child_resource_name(v)
      end.sort
    end

    def __missing_resources__(missing)
      resources_needed.each do |name|
        if !resources[name]
          missing[self] = name
        elsif resources[name].is_a? ResourceContainer
          resources[name].__missing_resources__(missing)
        end
      end
    end

  end
end
