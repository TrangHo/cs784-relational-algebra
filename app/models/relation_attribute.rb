class RelationAttribute < ApplicationRecord
  belongs_to :relation, inverse_of: :relation_attributes

  validates :relation, presence: true
  validates :name, uniqueness: { scope: [:relation_id], case_sensitive: false }

  TYPES = [
    VARCHAR_TYPE = 'varchar',
    DOUBLE_TYPE = 'double',
    INT_TYPE = 'int',
  ]
end
