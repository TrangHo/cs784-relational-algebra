class TestCase < ApplicationRecord
  belongs_to :problem, inverse_of: :test_cases
  validates :problem_id, presence: true
end
