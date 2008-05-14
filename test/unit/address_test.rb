require File.dirname(__FILE__) + '/../test_helper'

class AddressTest < Test::Unit::TestCase
  fixtures :addresses

  def test_01_must_be_either_user_or_customer_address
    # just a few quick queries, might be better on real world data
    assert_equal 0, Address.count(:conditions => ['owned_by_user = ? AND customer_id IS NOT NULL', true])
  end
end
