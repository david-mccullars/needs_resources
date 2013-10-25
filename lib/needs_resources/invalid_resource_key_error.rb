module NeedsResources
  class InvalidResourceKeyError < StandardError

    def initialize(name)
      super "Invalid resource key in config file: #{name.inspect}"
    end

  end
end