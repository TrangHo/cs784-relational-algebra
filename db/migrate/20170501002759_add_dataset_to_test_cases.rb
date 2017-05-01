class AddDatasetToTestCases < ActiveRecord::Migration[5.0]
  def change
    add_column :test_cases, :dataset, :jsonb, default: {}
  end
end
