module NeedsResources
  class InvalidOrCorruptedResourcesError < StandardError

    def initialize
      super "Invalid or corrupted resources config file"
    end

  end
end