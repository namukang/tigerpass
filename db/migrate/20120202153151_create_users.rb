class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :netid
      t.integer :fb_id
      t.integer :year
      t.integer :club_id
      t.integer :admin_id

      t.timestamps
    end
    add_index :users, :netid
    add_index :users, :fb_id
  end
end
