module NeedsResources
  class InvalidResourceAliasError < StandardError

    def initialize(name)
      super "Invalid resource alias in config file: #{name.inspect}"
    end

  end
end