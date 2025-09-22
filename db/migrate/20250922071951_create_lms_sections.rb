class CreateLmsSections < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_sections do |t|
      t.string :name
      t.belongs_to :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
