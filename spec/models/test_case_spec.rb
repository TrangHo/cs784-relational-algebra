require 'rails_helper'

RSpec.describe TestCase, type: :model do
  it { is_expected.to belong_to(:problem) }
  it { is_expected.to validate_presence_of(:problem_id) }
end
