class User < ActiveRecord::Base
  attr_accessible :netid, :fb_id, :year_id, :club_id

  belongs_to :club
  belongs_to :year

  validates :fb_id, presence: true
  validates :year_id, presence: true
  validates :netid, presence: true,  format: { with: netid_regex },
  uniqueness: true                                                               netid_regex = /\A[a-z]{1,8}\z

  has_and_belongs_to_many :events
end

