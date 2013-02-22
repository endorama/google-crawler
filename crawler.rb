#
# Web crawler to get google search results about search terms.
# 
# Use: ruby crawler.rb tag number_of_page_to_be_evaluated
#
# Results file will be saved in CSV format in a `scraped` folder, named
#   tag ( with spaces replaced with _ )-number_of_page_to_be_evaluated.csv
#
# `keywords` are the most found words in the results web page content. All words
# with a length less than WORD_LENGTH_THRESHOLD ( defaults to 3 ) are discharged
# as common ITALIAN stop words and some GENERIC stop words.
#
# Public Domain by Edoardo Tenani <edoardo.tenani@gmail.com>

require 'rubygems'
require 'csv'
require 'mechanize'
require 'open-uri'

require_relative 'lib/common_functions.rb'
require_relative 'lib/crawler.rb'

$LOG.level = Logger::INFO

AGENT_ALIASES = ['Linux Firefox', 'Linux Konqueror', 'Linux Mozilla', 'Mac Firefox', 'Mac Mozilla', 'Mac Safari 4', 'Mac Safari', 'Windows IE 6', 'Windows IE 7', 'Windows IE 8', 'Windows IE 9', 'Windows Mozilla']
SAVE_FOLDER = "scraped"
SLEEP_TIMES = [2,5,7,10,12,14]
WORD_LENGTH_THRESHOLD = 3

abort "#{$0} number_of_page_to_be_evaluated 'tag'" if (ARGV.size < 2)

number_of_page_to_be_evaluated = ARGV[0].to_i

if ARGV.size > 2
  arg_count = 1
  tag = ""
  while ARGV[arg_count]
    tag = tag + " #{ARGV[arg_count]}"
    arg_count += 1
  end
  tag.strip!
else
  tag = ARGV[1]
end

google_position = 1
sitesurl = Array.new
stop_words = load_stop_words

agent = Mechanize.new { |a|
  a.follow_meta_refresh = true
  a.user_agent_alias = AGENT_ALIASES.sample
}

$LOG.info "Starting elaboration for #{number_of_page_to_be_evaluated.to_s} page/s of google results with tag '#{tag}'"

agent.get("http://www.google.it/search?q=#{tag.gsub(/ /, '+')}") do |home_page|
  search_results = home_page

  for i in 1..number_of_page_to_be_evaluated
    $LOG.info "Scraping page #{i.to_s} of #{number_of_page_to_be_evaluated.to_s}"

    print "       "
    (search_results/"h3.r").each do |result|
      print '.'

      title = result.text
      url = CGI.parse((result/'a').attribute('href').value[5..-1])['q'][0]

      # check if url exists, is not empty and is a valid URI
      if url and not url.empty? and is_uri?(url)
        # p google_position.to_s + " - " + url

        keywords = get_word_frequencies url, stop_words

        # create site object to be stored in csv
        sitesurl << {
          :url => url,
          :search_tag => tag,
          :google_page => i,
          :google_position => google_position,
          # :domain => 
          :title => title,
          :keywords => keywords
        }

        google_position += 1
      end
    end
    print "\n"

    if i+1 <= number_of_page_to_be_evaluated
      sleep_time = SLEEP_TIMES.sample
      $LOG.info "[INFO] Page #{i.to_s} done, #{sleep_time} sec delay before page #{(i+1).to_s}"
      
      print "       "
      for j in 1..sleep_time
        print '.'
        sleep 1
      end
      
      print "\n"
    end

    begin
      search_results = agent.get("http://www.google.it/search?q=#{tag.gsub(/ /, '+')}&start=#{i*10}")
    rescue
      $LOG.warn "Cannot retrieve next results page. Tag: #{tag} | Page: #{i}"
    end
  end
end

filename = tag.gsub(' ', '_') + '-' + number_of_page_to_be_evaluated.to_s + ".csv"
$LOG.info "Writing to file scraped/#{filename}"

if not (File.exists?(SAVE_FOLDER) && File.directory?(SAVE_FOLDER))
  Dir.mkdir(SAVE_FOLDER)
end
CSV.open("#{SAVE_FOLDER}/" + filename, "w", { :force_quotes => true }) do |csv|
  csv << sitesurl[0].keys
  sitesurl.each do |site|
    ar = Array.new
    site.each { |key, value| ar << value }
    csv << ar
  end
end

$LOG.info "DONE"
