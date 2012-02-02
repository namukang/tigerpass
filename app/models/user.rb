# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  netid      :string(255)
#  fb_id      :integer
#  year       :integer
#  club_id    :integer
#  admin_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :netid, :fb_id, :year, :club_id

  validates :fb_id, presence: true
  validates :year, presence: true, inclusion: { in: [2012..2015] }
  validates :club_id, inclusion: { in: [0..10] }, allow_blank: true
  validates :netid, presence: true,  format: { with: netid_regex },
  uniqueness: true
  netid_regex = /\A[a-z]{1,8}\z/

  belongs_to :club
  has_and_belongs_to_many :events
end

