module NeedsResources
  class MissingResourceError < StandardError

    def initialize(*names)
      if names.size == 1
        super "The following resources is missing: #{names.first}."
      else
        super "The following resources are missing: #{names.to_sentence}."
      end
    end

  end
end