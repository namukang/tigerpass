# == Schema Information
#
# Table name: events
#
#  id           :integer         not null, primary key
#  club_id      :integer
#  date         :date
#  start_time   :time
#  end_time     :time
#  title        :string(255)
#  description  :text
#  access       :string(255)
#  image_small  :string(255)
#  image_poster :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Event < ActiveRecord::Base
  belongs_to :club
  has_and_belongs_to_many :users
  
  validates :club_id, presence: true
  validates :start_time, presence: true
  validates :date, presence: true
end
