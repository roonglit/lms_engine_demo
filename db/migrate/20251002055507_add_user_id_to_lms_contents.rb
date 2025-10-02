class AddUserIdToLmsContents < ActiveRecord::Migration[8.1]
  def change
    add_reference :lms_contents, :user, foreign_key: true
  end
end
