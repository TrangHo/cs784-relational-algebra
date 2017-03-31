require 'rails_helper'

RSpec.describe Relation, type: :model do
  it { is_expected.to belong_to(:problem) }
  it { is_expected.to validate_presence_of(:problem) }
  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:problem_id) }
end
