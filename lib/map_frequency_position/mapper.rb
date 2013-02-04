require 'csv'

require_relative '../common_functions.rb'

def clean_csv_row(row)
  row.each do |r|
    r.each do |k|
      k.strip!
    end
  end
end

def get_google_position(url)
  @positions.each do |p|
    if p[:url] == url
      return p[:google_position]
    end
  end
end

@positions = Array.new
urls = Array.new

CSV.foreach(ARGV[1], :headers => true) do |row|
  row = clean_csv_row(row)
  @positions << {
    :url => row[0],
    :google_position => row[1]
  }
end

@positions.uniq { |u| u[:url] }

CSV.foreach(ARGV[0], :headers => true) do |row|
  row = clean_csv_row(row)
  url = row[0]
  count = row[1]
  google_position = get_google_position url

  urls << {
    :url => url,
    :count => count,
    :google_position => google_position
  }
end

CSV.open("#{ARGV[2]}", "w", { :force_quotes => true }) do |csv|
  csv << urls[0].keys
  urls.each do |u|
    ar = Array.new
    u.each { |key, value| ar << value }
    csv << ar
  end
end
