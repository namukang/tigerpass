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

class DateValidator < ActiveModel::Validator
  def validate(record)
    unless record.date >= Date.today
      record.errors[:date] << 'Date cannot be in the past'
    end
  end
end

class Event < ActiveRecord::Base
  belongs_to :club
  has_and_belongs_to_many :users

  include ActiveModel::Validations
  validates_with DateValidator
  
  validates :club_id, presence: true, inclusion: { in: 0..10 }
  validates :start_time, presence: true
  validates :date, presence: true
  validates :title, length: { in: 3..100 }, allow_blank: true
  validates :description, length: { in: 2..750 }, allow_blank: true
  validates :access, presence: true, length: { in: 3..100 }
end
