module NeedsResources
  class RequiredAttributeError < StandardError

    def initialize(clazz, name)
      super "Missing resource in config file:  #{clazz} (in #{name})"
    end

  end
end