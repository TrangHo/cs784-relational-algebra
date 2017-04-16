class Relation < ApplicationRecord

  belongs_to :problem, inverse_of: :relations
  has_many :relation_attributes, inverse_of: :relation

  validates :problem, presence: true

  VALID_NAME_REGEX = /[_a-zA-Z][_a-zA-Z\d]*/
  validates :name, format: { with: VALID_NAME_REGEX, message: "should start with letter/underscore, and only contain letter/underscore/digit" }

  accepts_nested_attributes_for :relation_attributes, allow_destroy: true

end
