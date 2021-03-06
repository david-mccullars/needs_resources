module NeedsResources
  module ResourceType

    def self.included(base)
      children[underscore(base.name)] = base

      base.instance_eval do
        def attr(*names)
          options = names.last.is_a?(Hash) ? names.pop : {}
          names.flatten.each do |n|
            attributes[n.to_sym] = options.dup
            attr_reader n
          end
        end

        def provide_top_level_instance(name=nil, args={})
          name ||= ResourceType.underscore(self.name)
          TopLevelResources.instance.add_default(name, args)
        end

        def attributes
          @attributes ||= {}
        end
      end

      base.attr :name, :required => true
    end

    def self.underscore(name)
      name = name.to_s.dup
      name.gsub!(/^.*::/, '')
      name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      name.tr!("-", "_")
      name.downcase!
      name
    end

    def self.children
      @children ||= {}
    end

    def initialize(args={})
      args = args.dup
      self.class.attributes.each do |name, options|
        value = args.delete(name.to_s) || args.delete(name.to_sym) || options[:default].dup
        if options[:required] && value.nil?
          raise RequiredAttributeError.new(self, name)
        end
        instance_variable_set "@#{name}", value
      end
      args.each do |k, v|
        warn "Invalid initializer argument (#{k.inspect}) for class #{self}"
      end
    end

     def to_hash
      hash = {}
      simple_atts = self.class.attributes.keys - [:name, :resources]
      simple_atts.each do |a|
        v = instance_variable_get("@#{a}")
        hash[a.to_s] = v.respond_to?(:to_hash) ? v.to_hash : v
      end
      if respond_to?(:resources_hash)
        hash.merge! "resources" => resources_hash
      end
      hash
    end

  end
end
