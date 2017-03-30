class AddNameToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :name, :string
  end
end
