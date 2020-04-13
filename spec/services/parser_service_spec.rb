require 'rails_helper'
include CapybaraSessionHelper

describe ParserService do
  describe '#call' do
    subject do
      described_class.call
    end

    it 'succeeds' do
      expect(subject).to be_an_instance_of(Array)
      reset_session
    end
  end

  describe '#visit', type: :feature do
    it 'returns http success' do
      response = Net::HTTP.get_response(URI.parse('https://warm-taiga-57018.herokuapp.com/'))
      expect(response.kind_of? Net::HTTPSuccess).to be_truthy
    end
  end

  describe '#sign_in', type: :feature do
    before(:all) do
      visit '/'
      expect(page).to have_content 'LOGIN'

      within '#navbarResponsive' do
        click_link 'Login', href: '/users/sign_in'
      end

      expect(page).to have_content 'Log in'
    end

    it 'does not sign in with invalid params' do
      within '#new_user' do
        fill_in 'user_email', with: 'ben@gmail.com'
        fill_in 'user_password', with: '1234567'
        click_on 'Log in'
      end

      expect(page).to have_content 'Log in'
      use_current_session
    end

    it 'signs in with valid params' do
      within '#new_user'  do
        fill_in 'user_email', with: 'john@gmail.com'
        fill_in 'user_password', with: '123456'
        click_on 'Log in'
      end

      expect(page).to have_content 'LOGOUT'
      use_current_session
    end

    describe '#parse_posts', type: :feature do
      it 'finds posts to parse' do
        within '#all_posts' do
          expect(page).to have_css '.post-preview'
        end
      end
    end
  end
end
