class CreateStudent < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.uuid :authenticable_id
      t.string :authenticable_type
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end
  end
end
