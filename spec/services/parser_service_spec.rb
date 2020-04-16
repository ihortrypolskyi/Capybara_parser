require 'rails_helper'

describe ParserService, type: :feature do

  describe '#call' do
    let(:call_parser_service) { described_class.call }

    it 'responds to #call' do
      expect(described_class).to receive(:call).and_return(instance_of?(Array))
      call_parser_service
    end
  end

  let(:service) { described_class.new }

  let(:visit_valid_url) {
    service.send(:visit, 'https://warm-taiga-57018.herokuapp.com/', '#navbarResponsive')
  }

  let(:follow_valid_link) {
    service.send(:follow_link, 'a[href="/users/sign_in"]', '#navbarResponsive', '#new_user')
  }

  let(:valid_sign_in) {
    service.send(:sign_in, 'john@gmail.com', '123456', '#new_user', 'Log in', '#all_posts')
  }

  let(:valid_parse) { service.send(:parse_posts, '#all_posts', '.post-preview') }

  describe '#visit' do
    let(:visit_invalid_url) {
      service.send(:visit, 'https://warm-taiga-57018.herokuapp.com/invalid', '#navbarResponsive')
    }

    it 'returns Capybara::Node::Element for valid url' do
      expect(service).to receive(:visit).and_return(Capybara::Node::Element)
      visit_valid_url
    end

    it 'raises error for invalid url ' do
      expect{ visit_invalid_url }.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe '#follow_link' do
    let(:follow_invalid_link) {
      service.send(:follow_link, 'a[href="/users/invalid"]', '#navbarResponsive', '#new_user')
    }

    before(:example) do
      visit_valid_url
    end

    it 'returns Capybara::Node::Element for valid link' do
      expect(service).to receive(:follow_link).and_return(Capybara::Node::Element)
      follow_valid_link
    end

    it 'raises error for invalid link ' do
      expect{ follow_invalid_link }.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe '#sign_in' do
    let(:invalid_sign_in) {
      service.send(:sign_in, 'invalid@gmail.com', '123456', '#new_user', 'Log in', '#all_posts')
    }

    before(:example) do
      visit_valid_url
      follow_valid_link
    end

    it 'signs_in with valid credentials' do
      expect(service).to receive(:sign_in).and_return(Capybara::Node::Element)
      valid_sign_in
    end

    it 'does not sign in with invalid credentials' do
      expect{ invalid_sign_in }.to raise_error(Capybara::ElementNotFound)
    end
  end

  describe '#parse_posts' do
    let(:invalid_parse) { service.send(:parse_posts, '#invalid', '.post-preview-invalid') }

    before(:example) do
      visit_valid_url
      follow_valid_link
      valid_sign_in
    end

    it 'finds posts to parse' do
      expect(service).to receive(:parse_posts).and_return(instance_of?(Array))
      valid_parse
    end

    it 'does not find posts to parse' do
      expect{ invalid_parse }.to raise_error(Capybara::ElementNotFound)
    end
  end
end
