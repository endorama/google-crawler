require_relative '../common_functions.rb'
require_relative '../csv.rb'

tag = ARGV[0][/\/.*-/].gsub(/\//, '').gsub(/-/, '').gsub(/_/, ' ')

data = get_data_from_mapreduced_csv(ARGV[0])

data.each do |u|
  u[:tag] = tag
  p u
end

write_array_of_hashes_to_csv("tmp/#{tag.gsub(/ /, '_')}.all.csv", data)
