module RA
  module Predicate
    class Eq < Base

      def set_value(sample, type = nil)
        eval("sample['#{ self.left }'] = #{ self.right }")
      end
    end
  end
end
