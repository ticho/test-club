require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "valid connection" do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    post sessions_path, params: {email: 'lolilol@lol.com', password: 'qqqqq'}
    assert flash[:success], "Connection réussie."
  end
  test "empty" do
    post sessions_path, params: {}
    assert flash[:danger], "Adresse email ou mot de passe non valide."
  end
  test "email or pw invalid" do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    post sessions_path, params: {email: 'lolilol@lol.com', password: 'aqqqqq'}
    assert flash[:danger], "Adresse email ou mot de passe non valide."
  end
end
