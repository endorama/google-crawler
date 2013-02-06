require_relative '../common_functions.rb'
require_relative '../csv.rb'

final = Hash.new

data = get_data_from_file(ARGV[0])

data.each do |e|
  
  if final[e["url"]]
    final[e["url"]] = {
      :url => final[e["url"]][:url],
      :count => (final[e["url"]][:count].to_i + e["count"].to_i).to_s,
      :google_position => final[e["url"]][:google_position] + ', ' + e["google_position"],
      :tag => final[e["url"]][:tag] + ', ' + e["tag"]
    }
  else
    final[e["url"]] = {
      :url => e["url"],
      :count => e["count"],
      :google_position => e["google_position"],
      :tag => e["tag"]
    }

  end

end

write_array_of_hashes_to_csv('results/aggregate.csv', final.values)
