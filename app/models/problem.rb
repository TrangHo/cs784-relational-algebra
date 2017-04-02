class Problem < ApplicationRecord
  has_many :relations, inverse_of: :problem
  has_many :test_cases, inverse_of: :problem

  validates :description, :name, presence: true, uniqueness: { case_sensitive: false }
  validate :unique_inside_problem

  accepts_nested_attributes_for :relations, allow_destroy: true
  accepts_nested_attributes_for :test_cases, allow_destroy: true

  scope :approved, -> { where(approved: true) }

  before_save :set_slug, if: Proc.new { |o| o.name_changed? }

  private
  def set_slug
    self.slug = self.name.parameterize
  end

  def unique_inside_problem
    relation_names = Set.new
    for relation in relations
      if relation_names.include? relation.name.downcase
        errors.add(:relation, "contains duplicate relation names: #{relation.name}")
      end

      relation_names << relation.name.downcase
      relation_attribute_names = Set.new
      for relation_attribute in relation.relation_attributes
        if relation_attribute_names.include? relation_attribute.name.downcase
          errors.add(:relation, "contains duplicate relation attribute names: #{relation.name}.#{relation_attribute.name}")
        end

        relation_attribute_names << relation_attribute.name.downcase
      end
    end
  end
end
