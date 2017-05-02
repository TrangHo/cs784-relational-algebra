module RA
  module Predicate
    class JoinEq < Base

      ATTRS = [:left, :right, :type, :l_relation_name, :r_relation_name]
      attr_accessor *ATTRS

      def initialize(attributes = {})
        attributes = HashWithIndifferentAccess.new(attributes)
        self.left, self.l_relation_name = self.class.parse_left(attributes[:left], attributes[:l_relation_name])
        self.right, self.r_relation_name = self.class.parse_left(attributes[:right], attributes[:r_relation_name])
        self.type = attributes[:type]
      end

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
