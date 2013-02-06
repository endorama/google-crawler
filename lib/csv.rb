require 'csv'

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

def get_data_from_file(file)
  urls = Array.new
  
  CSV.foreach(file, :headers => true) do |row|
    row = clean_csv_row(row)
    urls << row.to_hash
  end
  
  urls
end


def get_data_from_mapreduced_csv(file)
  urls = Array.new

  CSV.foreach(file, :headers => true) do |row|
    row = clean_csv_row(row)
    url = row[0]
    count = row[1]
    google_position = row[2]

    urls << {
      :url => url,
      :count => count,
      :google_position => google_position
    }
  end

  urls
end

def write_array_of_hashes_to_csv(file, data)
  CSV.open("#{file}", "w", { :force_quotes => true }) do |csv|
    csv << data[0].keys
    data.each do |u|
      ar = Array.new
      u.each { |key, value| ar << value }
      csv << ar
    end
  end
end

def write_array_of_array_to_csv(file, data)
  CSV.open("#{file}", "w", { :force_quotes => true }) do |csv|
    csv << data[0][1].keys
    data.each do |d|
      ar = Array.new
      d[1].each do |u|
        ar << u[1]
      end
      csv << ar
    end
  end
end
