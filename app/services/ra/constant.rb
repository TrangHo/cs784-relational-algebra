# encoding: UTF-8
module RA
  module Constant
    OPERATORS = [
      SELECT = 'σ',
      JOIN = '⨝'
    ]
    UNARY_OPERATORS = [SELECT]
    BINARY_OPERATORS = [JOIN]
    CONJUNCTION = [
      AND = '∧',
      OR = '∨'
    ]
    COND_OPERATORS = [
      EQ = '=',
      NEQ = '!=',
      LESS = '<',
      LEQ = '<=',
      GREATER = '>',
      GEQ = '>='
    ]
    GROUPERS = [
      L_PARENTHESIS = '(',
      R_PARENTHESIS = ')',
    ]
  end
end
