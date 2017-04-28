module RA
  class Expression
    include ActiveModel::AttributeMethods

    ATTRS = [:operator, :operands, :conditions]

    attr_accessor *ATTRS

    def initialize(attributes = {})
      attributes = HashWithIndifferentAccess.new(attributes)
      self.operator = attributes[:operator]
      self.operands = attributes[:operands] || []
      self.conditions = attributes[:conditions] || []
    end

    def is_unary?
      Constant::UNARY_OPERATORS.include?(operator)
    end

    def is_relation?
      operator.nil?
    end
  end
end
