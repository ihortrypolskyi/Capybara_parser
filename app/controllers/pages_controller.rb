class PagesController < ApplicationController
  def home
  end

  def parse_site
    posts = ParserService.call
    CsvWriterService.call(posts)

    if posts.instance_of?(Array)
      flash[:notice] = 'Parsing completed'
    else
      flash[:alert] = 'Something went wrong'
    end

    Capybara.reset_sessions!

    redirect_to root_path
  end
end
