class Problem < ApplicationRecord
  has_many :relations, inverse_of: :problem
  has_many :test_cases, inverse_of: :problem

  scope :approved, -> { where(approved: true) }
end
