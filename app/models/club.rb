# == Schema Information
#
# Table name: clubs
#
#  id         :integer         not null, primary key
#  short_name :string(255)
#  long_name  :string(255)
#  logo       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Club < ActiveRecord::Base
  has_many :users
  has_many :events
  has_many :admins, class_name: "User", foreign_key: "admin_id"
end

