class RelationAttribute < ApplicationRecord
  belongs_to :relation, inverse_of: :relation_attributes

  validates :relation, presence: true
  VALID_NAME_REGEX = /[_a-zA-Z][_a-zA-Z\d]*/
  validates :name, format: { with: VALID_NAME_REGEX, message: "should start with letter/underscore, and only contain letter/underscore/digit" }

  TYPES = [
    VARCHAR_TYPE = 'varchar',
    DOUBLE_TYPE = 'double',
    INT_TYPE = 'int',
  ]
end
