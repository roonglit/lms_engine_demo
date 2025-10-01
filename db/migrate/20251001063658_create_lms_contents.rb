class CreateLmsContents < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_contents do |t|
      t.string :title
      t.string :subtitle
      t.string :description
      t.belongs_to :contentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
