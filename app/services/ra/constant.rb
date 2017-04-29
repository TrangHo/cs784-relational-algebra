# encoding: UTF-8
module RA
  module Constant
    RELATION_TYPES = [
      RELATION = 'ID',
      SELECT = 'select',
    ]
    UNARY_OPERATORS = [SELECT]
    # BINARY_OPERATORS = [JOIN]
    PREDICATE_TYPES = [
      EQ = '==',
      NEQ = '!=',
      LESS = '<',
      LEQ = '<=',
      GREATER = '>',
      GEQ = '>=',
      AND = 'and',
      OR = 'or',
    ]
    CONJUNCTION = [AND, OR]
    COND_OPERATIONS = [
      EQ, NEQ, LESS, LEQ, GREATER, GEQ, AND, OR
    ]
  end
end
