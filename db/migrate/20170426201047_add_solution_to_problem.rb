class AddSolutionToProblem < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :solution, :string
  end
end
