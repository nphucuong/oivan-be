class CreateQuestion < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.references :test
      t.string :label
      t.text :question_content

      t.timestamps
    end
  end
end
