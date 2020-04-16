class CsvWriterService < ApplicationService
  require 'csv'

  def initialize(args)
    @args = args
  end

  def call
    to_csv(@args)
  end

  private

  def to_csv(args)
    file = "#{Rails.root}/public/parsed_data.csv"
    headers = ['ID', 'Title', 'Subtitle']
    ids_column = CSV.foreach(file).map { |row| row[0] }

    CSV.open(file, 'a+') do |csv|
      csv << headers if csv.count.eql? 0

      args.each do |arg|
        csv << arg if ids_column.exclude? args[0][0]
      end
    end
  end
end
