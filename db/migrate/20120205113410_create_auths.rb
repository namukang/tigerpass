class CreateAuths < ActiveRecord::Migration
  def change
    create_table :auths do |t|
      t.string :netid
      t.integer :admin_id
      t.integer :fb_id
      t.string :code

      t.timestamps
    end
  end
end
