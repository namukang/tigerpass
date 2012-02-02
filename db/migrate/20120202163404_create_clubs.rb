class CreateClubs < ActiveRecord::Migration
  def change
    create_table :clubs do |t|
      t.string :short_name
      t.string :long_name
      t.string :logo

      t.timestamps
    end
  end
end
