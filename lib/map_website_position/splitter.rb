require 'csv'

require_relative '../common_functions.rb'

CSV.foreach(ARGV[0], :headers => true) do |row|
  line = row[0].strip.chomp.gsub(/"/, '')

  if is_uri?(line)
    print "#{URI(line).host},#{row[3]}\n"
  end
end
