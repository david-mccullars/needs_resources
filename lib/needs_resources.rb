require 'set'

module NeedsResources

  def needs_resources(*names)
    container = is_a?(ResourceContainer) ? self : TopLevelResources.instance
    names.flatten.each do |name|
      if is_a? Class
        define_method name, lambda { container[name] }
      end
      define_singleton_method name, lambda { container[name] }
      container.resources_needed << name.to_sym
    end
  end

  alias :needs_resource :needs_resources

  def self.ensure_resources
    if (missing = missing_resources).any?
      # TODO: maybe prompt user if missing?
      raise MissingResourceError.new(*missing)
    end
  end

  def self.missing_resources
    TopLevelResources.instance.missing_resources
  end

  extend Enumerable

  def self.each(&block)
    TopLevelResources.instance.each(&block)
  end

end

Dir[File.expand_path('../needs_resources/**/*.rb', __FILE__)].sort.each do |f|
  load f
end
