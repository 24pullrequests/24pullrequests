class AppDecorator < Draper::Decorator
  class << self
    attr_accessor :attributes

    def attributes(*args)
      self.class_eval do
        define_method(:attributes) do
          args.inject({}) do |memo, item|
            memo[item] = self.send(item)
            memo
          end
        end
      end
    end
  end
end
