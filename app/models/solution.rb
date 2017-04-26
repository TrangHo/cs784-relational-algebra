class Solution < ApplicationRecord
  belongs_to :problem, inverse_of: :solution
  validates :problem_id, presence: true
end