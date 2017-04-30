module RA
  module Predicate
    class Geq < Base

      def set_value(sample, type)
        sample[self.left] = [
          eval("#{ self.right }"),
          Greater.new.set_value(sample, type)
        ].sample
      end
    end
  end
end
