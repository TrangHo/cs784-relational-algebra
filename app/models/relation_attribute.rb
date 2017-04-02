class RelationAttribute < ApplicationRecord
  belongs_to :relation, inverse_of: :relation_attributes

  validates :relation, presence: true
  validates :name, uniqueness: { scope: [:relation_id], case_sensitive: false }

  TYPES = [
    STRING_TYPE = 'String',
    NUMBER_TYPE = 'Number'
  ]
end
