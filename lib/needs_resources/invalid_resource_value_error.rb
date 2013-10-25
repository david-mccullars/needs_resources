module NeedsResources
  class InvalidResourceValueError < StandardError

    def initialize(name, value)
      super "Invalid resource value in config file for #{name.inspect}: #{value.inspect}"
    end

  end
end