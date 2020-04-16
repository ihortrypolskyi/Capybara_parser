class ParserService < ApplicationService

  def initialize
    @browser = Capybara.current_session
    @driver = @browser.driver.browser
  end

  def call
    rescue_exception do
      visit('/', '#navbarResponsive')
      follow_link(
        'a[href="/users/sign_in"]',
        '#navbarResponsive',
        '#new_user'
      )
      sign_in(
        'john@gmail.com',
        '123456',
        '#new_user',
        'Log in',
        '#all_posts'
      )
      parse_posts('#all_posts','.post-preview')
    end
  end

  private

  def visit(url = nil, expectation)
    @browser.visit(url)
    @browser.find(expectation)
  end

  def follow_link(href, within_node, expectation)
    @browser.within(within_node) do
      @browser.find(href).click
    end
    @browser.find(expectation)
  end

  def sign_in(email, password, within_node, node, expectation)
    @browser.within(within_node) do
      @browser.fill_in('user_email', with: email)
      @browser.fill_in('user_password', with: password)
      @browser.click_on(node)
    end
    @browser.find(expectation)
  end

  def parse_posts(within_node, node)
    loop do
      sleep(2)
      if @driver.execute_script('return document.readyState') == 'complete'
        break
      end
    end

    @browser.within(within_node) do
      posts = @browser.all(node)

      if posts.size > 0
        parsed_data = []

        posts.each do |post|
          id = post.all('a').first['href'].split('/').last
          title = post.find('.post-title').text
          subtitle = post.find('.post-subtitle').text

          parsed_data << [id, title, subtitle]
        end
      end

      Capybara.reset_sessions!

      parsed_data
    end
  end

  def rescue_exception
    yield
  rescue => e
    Capybara.reset_sessions!
    e.message
  end
end
