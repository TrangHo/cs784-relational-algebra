class Relation < ApplicationRecord
  belongs_to :problem, inverse_of: :relations
  has_many :relation_attributes, inverse_of: :relation

  validates :problem, presence: true
  validates :name, uniqueness: { scope: [:problem_id] }

  accepts_nested_attributes_for :relation_attributes, allow_destroy: true
end
