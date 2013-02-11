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

final = final.sort_by { |key, value| value[SORT_BY].to_i }

if REVERSE
  final.reverse!
end

tags.uniq!

data = Array.new
final.each do |d|
  ps = d[1][:google_position].split(', ')
  ts = d[1][:tag].split(', ')

  data << {
    :url => d[1][:url],
    :count => d[1][:count],
  }

  tags_positions = Array.new
  for i in 0..ts.length
    if ts[i]
      tags_positions << {
        :tag => ts[i],
        :position => ps[i]
      }
    end
  end

  tags.each do |t|
    tag_text = "tag_#{tags.index(t)}"
    position_text = "position_#{tags.index(t)}"
    # tag_text = "tag-#{t.gsub(/ /, '_')}"
    # position_text = "position-#{t.gsub(/ /, '_')}"
    
    if ts.include? t
      data.last[tag_text] = t
      data.last[position_text] = tags_positions.select { |x| x[:tag] == t }[0][:position]
    else
      data.last[tag_text] = t
      data.last[position_text] = 0
    end
  end
end

$LOG.debug "data.last is #{data.last}"

main_tag = ""
tags.each do |t|
  if t.split.length > 1
    main_tag = t.split[0]
  elsif t.split.length == 1
    unless main_tag == t.split[0]
      p "urgh!"
    end
  end
end

$LOG.debug "main_tag is #{main_tag}"

filename = main_tag + "-" + Digest::MD5.hexdigest(tags.each {|t| t.gsub(/ /, '_')}.join('-'))
File.open("results/#{filename}.txt", 'w') {|f| f.write(tags.join("\n")) }

filename = "#{filename}.#{ARGV[1]}.aggregate.test.csv"
$LOG.debug "filename is #{filename}"
write_array_of_hashes_to_csv("results/#{filename}", data)
