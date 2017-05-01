module RA
  module Predicate
    class Eq < Base

      def set_value(sample, type = nil)
        eval("sample['#{ self.left }'] = #{ self.right }")
      end

      def apply_to(dataset)
        dataset.select do |tuple|
          tuple[self.left] == eval("#{ self.right }")
        end
      end
    end
  end
end
