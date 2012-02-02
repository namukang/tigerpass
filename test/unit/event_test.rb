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

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
