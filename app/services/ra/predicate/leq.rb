module RA
  module Predicate
    class Leq < Base

      def set_value(sample, type)
        sample[self.left] = [
          eval("#{ self.right }"),
          Less.new.set_value(sample, type)
        ].sample
      end
    end
  end
end
