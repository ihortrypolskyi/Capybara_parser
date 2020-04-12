class ParserService < ApplicationService
  require 'csv'

  def call
    visit
    sign_in
    parse_posts
  end

  private

  def visit
    @browser = Capybara.current_session
    @driver = @browser.driver.browser
    @browser.visit('/')
  end

  def sign_in
    @browser.within('#navbarResponsive') do
      @browser.click_link('Login', href: "/users/sign_in")
    end

    @browser.within('#new_user') do
      @browser.fill_in('user_email', with: 'john@gmail.com')
      @browser.fill_in('user_password', with: '123456')
      @browser.click_on('Log in')
    end
  end

  def parse_posts
    loop do
      sleep(2)
      if @driver.execute_script('return document.readyState') == 'complete'
        break
      end
    end

    @browser.within('#all_posts') do
      posts = @browser.all('.post-preview')

      if posts.size > 0
        parsed_data = []
        posts.each_with_index do |post, i |
          id = post.all('a').first['href'].split('/').last
          title = post.find('.post-title').text
          subtitle = post.find('.post-subtitle').text

          parsed_data << [id, title, subtitle]
        end
      end

      parsed_data
    end
  end
end
