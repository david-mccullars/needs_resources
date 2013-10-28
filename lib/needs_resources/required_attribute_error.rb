module NeedsResources
  class RequiredAttributeError < StandardError

    def initialize(obj, name)
      super "Missing resource in config file:  #{name} (in #{obj.respond_to?(:name) ? obj.name : obj.to_s})"
    end

  end
end