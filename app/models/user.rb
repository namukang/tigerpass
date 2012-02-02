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
  belongs_to :club
  belongs_to :club_as_admin, class_name: "Club", foreign_key: "admin_id"
  has_and_belongs_to_many :events

  attr_accessible :netid, :fb_id, :year, :club_id

  validates :fb_id, presence: true, uniqueness: true
  validates :year, presence: true, inclusion: { in: 2012..2015 }
  validates :netid, format: { with: /\A[a-z]{1,8}\z/ }, uniqueness: true
  validates :club_id, inclusion: { in: 0..10 }, allow_nil: true
  validates :admin_id, inclusion: { in: 0..10 }, allow_nil: true
  
end

