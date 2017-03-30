class Relation < ApplicationRecord
  belongs_to :problem, inverse_of: :relations
  validates :problem_id, presence: true
  validates :name, uniqueness: { scope: [:problem_id] }
end
