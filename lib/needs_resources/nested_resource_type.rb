module NeedsResources
  module NestedResourceType

    def self.included(base)
      base.send :include, ResourceType
      base.send :include, ResourceContainer
      base.send :include, NeedsResources

      base.attr :resources, :default => {}
    end

  end
end