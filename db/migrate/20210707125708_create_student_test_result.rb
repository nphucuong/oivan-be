class CreateStudentTestResult < ActiveRecord::Migration[6.1]
  def change
    create_table :student_test_results do |t|
      t.references :student
      t.references :test
      t.integer :result, default: [], array: true
      t.float :score
      
      t.timestamps
    end
  end
end
