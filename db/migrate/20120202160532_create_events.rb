class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer, :club_id
      t.date, :date
      t.time, :start_time
      t.time, :end_time
      t.string, :title
      t.text, :description
      t.string, :access
      t.string, :image_small
      t.string :image_poster

      t.timestamps
    end
  end
end
