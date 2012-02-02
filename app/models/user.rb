class User < ActiveRecord::Base
  attr_accessible :netid, :fb_id, :year_id, :club_id

  validates :fb_id, presence: true
  validates :year, presence: true, inclusion: { in: valid_years }
  valid_years = [2012, 2013, 2014, 2015]
  validates :netid, presence: true,  format: { with: netid_regex },
  uniqueness: true                                                               netid_regex = /\A[a-z]{1,8}\z

  belongs_to :club
  has_and_belongs_to_many :events
end

