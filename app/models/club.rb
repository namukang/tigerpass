class Club < ActiveRecord::Base
  has_many :users
  has_many :events
  has_many :admins, class_name: "User", foreign_key: "admin_id"
end

