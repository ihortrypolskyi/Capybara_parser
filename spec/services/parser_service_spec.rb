require 'rails_helper'

describe ParserService do
  after(:each) do
    Capybara.reset_sessions!
  end

  describe '#call' do
    subject do
      described_class.call
    end

    it 'succeeds' do
      expect(subject).to be_an_instance_of(Array)
    end
  end

  describe '#visit', type: :feature do
    it 'returns http success' do
      visit '/'
      expect(page).to have_http_status(:ok)
    end
  end

  describe '#sign_in', type: :feature do
    before do
      visit '/'

      within('#navbarResponsive') do
        click_link('Login', href: '/users/sign_in')
      end
    end

    it 'sign in with valid params' do
      within('#new_user') do
        fill_in 'user_email', with: 'john@gmail.com'
        fill_in 'user_password', with: '123456'
        click_on 'Log in'
      end

      expect(page).to have_content 'HOW DEE, JOHN?'
    end

    it 'sign in with invalid params' do
      within('#new_user') do
        fill_in 'user_email', with: 'ben@gmail.com'
        fill_in 'user_password', with: '1234567'
        click_on 'Log in'
      end

      expect(page).to have_content 'Log in'
    end
  end
end