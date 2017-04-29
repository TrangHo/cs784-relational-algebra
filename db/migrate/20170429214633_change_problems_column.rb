class ChangeProblemsColumn < ActiveRecord::Migration[5.0]
  def up
    remove_column :problems, :solution_json
    add_column :problems, :solution_json, :jsonb, default: {}
  end

  def down
    remove_column :problems, :solution_json
    add_column :problems, :solution_json, :string
  end
end
