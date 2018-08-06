# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # testing the signup page
  test 'valid user' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: 'thp',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    assert flash[:success], 'Inscription validée ! Vous avez maintenant accès à la page club.'
  end
  test 'empty' do
    post sessions_path, params: {}
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end
  test 'email isnt valid' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: 'thp',
        email: 'lolilollol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
    refute User.find_by(email: 'lolilol')
  end
  test 'email isnt free' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: 'thp',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    post users_path, params: {
      user: {
        first_name: 'tibi',
        last_name: 'thpi',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end
  test 'no first name ' do
    post users_path, params: {
      user: {
        first_name: '',
        last_name: 'thp',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end
  test 'only spaces in last name' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: '      ',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'qqqqq'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end
  test 'password too short' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: 'thp',
        email: 'lolilol@lol.com',
        password: 'qqq',
        password_confirmation: 'qqq'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end
  test 'password doesnt match confirmation' do
    post users_path, params: {
      user: {
        first_name: 'tib',
        last_name: 'thp',
        email: 'lolilol@lol.com',
        password: 'qqqqq',
        password_confirmation: 'eeeee'
      }
    }
    assert flash[:danger], 'Erreur, veuillez reessayer.'
  end

  # testing the show page
  test 'accessible from navbar while connected' do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    post sessions_path, params: {email: 'lolilol@lol.com', password: 'qqqqq'} 
    get root_path
    assert_select 'a', "Ma page"
  end

  test 'accessing own show page while connected' do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    post sessions_path, params: {email: 'lolilol@lol.com', password: 'qqqqq'}
    get user_path(user.id)
    assert_select 'h1', 'Ma page'
    assert_select 'table tbody tr td', user.first_name
    assert_select 'table tbody tr td', user.last_name
    assert_select 'table tbody tr td', user.email
  end

  test 'accessing show page while not connected' do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    get user_path(user.id)
    assert flash[:danger], 'Vous devez vous connecter pour acceder à cette page.'
    assert request.env['PATH_INFO'], root_path
  end
  test 'accessing someone elses page' do
    user = User.create(
      first_name: 'tibo',
      last_name: 'thp',
      email: 'lolilol@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    user2 = User.create(
      first_name: 'tibo2',
      last_name: 'thp',
      email: 'lolilol2@lol.com',
      password: 'qqqqq',
      password_confirmation: 'qqqqq'
    )
    post sessions_path, params: {email: 'lolilol@lol.com', password: 'qqqqq'}
    get user_path(user2.id) 
    assert flash[:danger], 'Vous n\'avez pas accès à la page de cet utilisateur.'
    assert request.env['PATH_INFO'], root_path
  end
end
