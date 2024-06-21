module Attributes
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attribute(name, default: nil)
      define_method(name) do
        instance_variable_get("@#{name}") || default
      end

      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end
    end
  end
end
