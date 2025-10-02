class CreateLmsVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :lms_videos do |t|
      t.timestamps
    end
  end
end
