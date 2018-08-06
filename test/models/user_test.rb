require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'valid user' do
    user = User.new(
      first_name: 'tibo',
      last_name: 'thp',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    )
    assert user.valid?
  end
  test 'invalid without first_name' do
    user = User.new(
      first_name: 'tibo',
      last_name: '',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    )
    refute user.valid?, 'user is valid without a name'
    user = User.new(
      first_name: 'tibo',
      last_name: '     ',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    )
    assert_not_nil user.errors[:last_name], 'last name cant be spaces only'
  end
  test 'invalid without email' do
    user = User.new(
      first_name: 'tibo',
      last_name: 'thp',
      password: 'qqqqq',
      email: 'tibolol.com'
    )
    assert_not_nil user.errors[:email], 'email must be valid'
  end
  test 'invalid without password' do
    user = User.new(
      first_name: 'tibo',
      last_name: 'thp',
      password: 'qqq',
      email: 'tibo@lol.com'
    )
    assert_not_nil user.errors[:password], 'password must be at least 5 char long'
  end
  test 'email must be unique' do
    User.new(
      first_name: 'tibo',
      last_name: 'thp',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    ) 
    user = User.new(
      first_name: 'tibi',
      last_name: 'thpi',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    )
    assert_not_nil user.errors[:email], 'email must be unique'
  end
end
