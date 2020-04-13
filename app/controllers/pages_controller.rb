class PagesController < ApplicationController
  def home
  end

  def parse_site
    service_responce = ParserService.call

    if service_responce.instance_of?(Array)
      CsvWriterService.call(service_responce)
      flash[:success] = "Parsing completed with: #{service_responce}"
    else
      flash[:alert] = "Parsing failed with: #{service_responce}"
    end

    redirect_to root_path
  end
end
