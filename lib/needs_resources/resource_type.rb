module NeedsResources
  module ResourceType

    def self.included(base)
      children[base.name.demodulize.underscore] = base
      base.instance_eval do
        def attr(*names)
          options = names.last.is_a?(Hash) ? names.pop : {}
          names.flatten.each do |n|
            attributes[n] = options.with_indifferent_access
            attr_reader n
          end
        end

        def attributes
          @attributes ||= {}.with_indifferent_access
        end
      end
      base.attr :name, :required => true
    end

    def self.children
      @children ||= {}
    end

    def initialize(args={})
      args = args.with_indifferent_access
      self.class.attributes.each do |name, options|
        value = args.delete(name) || options[:default]
        if options[:required] && value.nil?
          raise RequiredAttributeError.new(self, name)
        end
        value = value.with_indifferent_access if value.is_a? Hash
        instance_variable_set "@#{name}", value
      end
      args.each do |k, v|
        warn "Invalid initializer argument (#{k.inspect}) for class #{self}"
      end
    end

  end
end