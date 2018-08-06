require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  include SessionsHelper

  test "should get index" do
    get "/"
    assert_response :success
  end

  test "navbar links to home" do
    get root_path
    assert_select 'nav a[href=?]', root_path
  end

  # user not logged in
  test "should link to login if not logged in" do
    get root_path
    assert_select 'div.container a.login[href=?]', new_session_path
  end
  test "navbar should link to login if not logged in" do
    get root_path
    assert_select 'nav a.login[href=?]', new_session_path
  end
  test "should link to create account if not logged in" do
    get root_path
    assert_select 'div.container a[href=?]', new_user_path
  end

  # user logged in
  test "signed in user" do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      password: 'qqqqq',
      email: 'tibo@lol.com'
    )
    post sessions_path, params: { "email" => user.email, "password" => user.password }
    get root_path
    assert_select 'nav a', 'Logout', 'Logout button when signed in'
    assert_select 'nav a[href=?]', club_url, nil, 'secret page url in navbar when signed in'
    assert_select 'nav a[href=?]', root_path, nil, 'root_path when signed in'
    assert_select 'nav span', "Connecté en tant que #{user.first_name} #{user.last_name}", 'connected as ... '

    # testing access to the club page
    get club_url
    assert request.env['PATH_INFO'], "/static_pages/club_page"
    # checking page's content
    assert_select 'table tbody tr td', user.first_name, 'first name appears in the list'
    assert_select 'table tbody tr td', user.last_name, 'last name appears in the list'
    assert_select 'table tbody tr td', user.email, 'email name appears in the list'
  end

  test "club page when not signed in" do
    get club_url
    assert flash[:danger], "Vous devez vous connecter pour accéder à cette page."
    assert request.env['PATH_INFO'], "/"
  end
end
