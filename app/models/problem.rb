class Problem < ApplicationRecord
  has_many :relations, inverse_of: :problem
  has_many :test_cases, inverse_of: :problem

  validates :description, :name, presence: true

  accepts_nested_attributes_for :relations, allow_destroy: true
  accepts_nested_attributes_for :test_cases, allow_destroy: true

  scope :approved, -> { where(approved: true) }

  before_save :set_slug, if: Proc.new { |o| o.name_changed? }

  private
  def set_slug
    self.slug = self.name.parameterize
  end
end
