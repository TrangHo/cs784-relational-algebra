class AddSolutionJsonToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :solution_json, :string
  end
end
