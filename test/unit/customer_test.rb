require File.dirname(__FILE__) + '/../test_helper'

class CustomerTest < ActiveSupport::TestCase
  fixtures :customers

  def test_01_invoices
    customer1 = Customer.find 1
    user1 = User.find 1
    assert_equal customer1.invoices.find(:first), Invoice.find(:first)
    assert_equal customer1.invoices.find(:first).sender_address, user1.user_addresses.find(:first)
  end
end
