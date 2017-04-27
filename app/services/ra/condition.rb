module RA
  class Condition
    include ActiveModel::AttributeMethods

    ATTRS = [:operator, :l_operand, :r_operand]

    attr_accessor *ATTRS

    def initialize(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      self.operator = attributes[:operator]
      self.l_operand = attributes[:l_operand]
      self.r_operand = attributes[:r_operand]
    end
  end
end
