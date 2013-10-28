module NeedsResources
  module ResourceContainer

    def [](name)
      resources[name.to_sym] or raise MissingResourceError.new(child_resource_name name)
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
