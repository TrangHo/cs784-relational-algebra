class AddSlugToProblems < ActiveRecord::Migration[5.0]
  def change
    add_column :problems, :slug, :string
    add_index :problems, :slug
  end
end
