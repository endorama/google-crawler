require 'digest/md5'

require_relative '../common_functions.rb'
require_relative '../csv.rb'

SORT_BY = :count
REVERSE = true

final = Hash.new
tags = Array.new

data = get_data_from_file(ARGV[0])

data.each do |e|
  tags << e["tag"]
  
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

unless REVERSE
  final = final.sort_by { |key, value| value[SORT_BY].to_i }
else
  final = final.sort_by { |key, value| value[SORT_BY].to_i }.reverse
end

tags.uniq!
filename = Digest::MD5.hexdigest(tags.each {|t| t.gsub(/ /, '_')}.join('-'))
File.open("results/#{filename}.txt", 'w') {|f| f.write(tags.join("\n")) }

write_array_of_array_to_csv("results/#{filename}.#{ARGV[1]}.aggregate.csv", final)
