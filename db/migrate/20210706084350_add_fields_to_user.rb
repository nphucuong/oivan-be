class AddFieldsToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :authenticable_id, :integer
    add_column :users, :authenticable_type, :string
  end
end
