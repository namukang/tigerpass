class Event < ActiveRecord::Base
  validates :club_id, presence: true
  validates :start_time, presence: true
  validates :date, presence: true

  belongs_to :club
  has_and_belongs_to_many :users
end
