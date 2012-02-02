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

require 'test_helper'

class ClubTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
