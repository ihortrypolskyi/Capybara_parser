class ScraperService < ApplicationService

  def call
    visit
    parse
  end

  private

  def visit
    @browser = Capybara.current_session
    @driver = @browser.driver.browser
    @browser.visit "https://angel.co/companies"
    @browser.find('.search-box').click
    @browser.find('.keyword-input').set("Bloom")
    @browser.find('.keyword-input').native.send_keys(:return)
  end

  def parse
    #loop do
      # Wait browser to load
      loop do
        sleep(2)
        if @driver.execute_script('return document.readyState') == "complete"
          break
        end
      end

      # Load page
      doc = Nokogiri::HTML(@driver.page_source);
      companies = doc.css("div.results > div[data-_tn='companies/row']");
      puts companies.count
        #  if companies.count > 0
    #    # Print companies
    #    companies.each do |company|
    #      # This ID is unique!
    #      name_a = company.css("div.startup > div.company div.name a");
    #      if name_a && !name_a.empty?
    #        id = company.css("div.startup > div.company div.name a").attr('data-id').text;
    #      else
    #        next
    #      end
    #      name = company.css("div.startup > div.company div.name").text.strip!
    #      pitch = company.css("div.startup > div.company div.pitch").text.strip!
    #      puts "id: #{id}"
    #      puts "name: #{name}"
    #      puts "pitch: #{pitch}"
    #      puts "=="
    #    end
    #
    #    ## Remove old companies
    #    #script = "$(\"div.results > div[data-_tn='companies/row']\").remove();"
    #    #driver.execute_script(script);
    #    #
    #    ## Load new companies
    #    #if browser.has_css?('.more')
    #    #  browser.find('.more').click
    #    #end
    #  #end
    #end
  end
end