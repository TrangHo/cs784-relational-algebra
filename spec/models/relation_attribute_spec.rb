require 'rails_helper'

RSpec.describe RelationAttribute, type: :model do
  it { is_expected.to belong_to(:relation) }
  it { is_expected.to validate_presence_of(:relation) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:relation_id) }
end
