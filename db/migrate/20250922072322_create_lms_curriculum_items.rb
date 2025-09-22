class CreateLmsCurriculumItems < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_curriculum_items do |t|
      t.string :title
      t.belongs_to :section, null: false, foreign_key: true

      t.timestamps
    end
  end
end
