module Delegates
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def delegate(*method_names, to:)
      method_names.each do |name|
        define_method(name) do
          send(to).send(name)
        end
      end
    end
  end
end
