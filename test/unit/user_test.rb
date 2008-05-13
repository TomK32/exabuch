require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase

  # should have one user_address and two addresses (includes the own one)
  def test_01_addresses
    user1 = User.find 1
    assert_equal 1, user1.addresses.count
    assert_equal 1, user1.user_addresses.count
    assert_not_equal user1.addresses.first, user1.user_addresses.first
    assert_equal 'Wollewolle Inc., 21138 Berlin', user1.user_addresses.first.short_info
    assert_equal Address.find(2).short_info, user1.addresses.first.short_info
  end
end
