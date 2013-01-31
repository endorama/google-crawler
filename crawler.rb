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
require 'uri'

def is_uri?(string)
  uri = URI.parse(string)
  %w( http https ).include?(uri.scheme)
rescue URI::BadURIError
  false
rescue URI::InvalidURIError
  false
end

SLEEP_TIME = 5
WORD_LENGTH_THRESHOLD = 3

abort "#{$0} tag number_of_page_to_be_evaluated" if (ARGV.size != 2)

tag = ARGV[0]
number_of_page_to_be_evaluated = ARGV[1].to_i

frequency = Hash.new(0)
google_position = 1
keywords = Array.new
sitesurl = Array.new
stop_words = Array.new

italian_stop_words = File.readlines("utils/italian_stop_words.txt").each { |line| line.chomp!.strip! }
generic_stop_words = File.readlines("utils/generic_stop_words.txt").each { |line| line.chomp!.strip! }
stop_words = stop_words.concat(italian_stop_words).concat(generic_stop_words)

agent = Mechanize.new { |a|
  a.follow_meta_refresh = true
  a.user_agent_alias = 'Linux Firefox'
}

print '[INFO] Starting elaboration for ' + number_of_page_to_be_evaluated.to_s + ' page/s of google results with tag "' + tag + "\"\n"

agent.get("http://www.google.com") do |home_page|

  search_results = home_page.form_with(:name => "f") do |form|
    form.q = tag
  end.submit

  for i in 1..number_of_page_to_be_evaluated
    print '[INFO] Scraping page ' + i.to_s + ' of ' + number_of_page_to_be_evaluated.to_s + ' '

    (search_results/"h3.r").each do |result|
      print '.'

      title = result.text
      url = CGI.parse((result/'a').attribute('href').value[5..-1])['q'][0]

      # check if url exists, is not empty and is a valid URI
      if url and not url.empty? and is_uri?(url)
        # p google_position.to_s + " - " + url

        frequency = Hash.new(0)
        keywords = Array.new
        
        # get keywords from content
        begin
          site = Nokogiri::HTML(open(url))

          encoding_options = {
            :invalid           => :replace,  # Replace invalid byte sequences
            :undef             => :replace,  # Replace anything not defined in ASCII
            :replace           => '',        # Use a blank for those replacements
            :universal_newline => true       # Always break lines with \n
          }
          text = site.xpath('//body').text.encode Encoding.find('ASCII'), encoding_options
          
          words = text.split(/[^a-zA-Z]/).reject! { |c| c.empty? }
          words.each { |w|
            frequency[w] += 1
          }
          frequency = frequency.sort_by { |x,y| y }
          frequency.reverse!

          frequency.map do |array|
            word = array[0].downcase.strip
            if word.length > WORD_LENGTH_THRESHOLD and not stop_words.include? word
              keywords << array[0]
            end
          end

          keywords = keywords[1..10].join(', ')
        rescue OpenURI::HTTPError => e
          print "\n" + google_position.to_s + ' - Cannot retrieve URL for processing: ' + e.to_s + "\n"
        rescue Exception => e
          print "\n" + 'Some error happened: ' + e.to_s + "\n"
        end

        # create site object to be stored in csv
        sitesurl << {
          :url => url,
          :title => title,
          :google_page => i,
          :google_position => google_position,
          :keywords => keywords
        }

        google_position += 1
      end
    end
    print "\n"

    search_results = search_results.link_with(:text => 'Avanti').click

    if i+1 < number_of_page_to_be_evaluated
      print '[INFO] Page ' + i.to_s + ' done, 5 sec delay before page ' + (i+1).to_s + ' '
      
      for i in 1..SLEEP_TIME
        print '.'
        sleep 1
      end
      
      print "\n"
    end
  end
end

filename = tag.gsub(' ', '_') + '-' + number_of_page_to_be_evaluated.to_s + ".csv"
print '[INFO] Writing to file scraped/' + filename + "\n"

CSV.open('scraped/' + filename, "w", {:force_quotes=>true}) do |csv|
  csv << sitesurl[0].keys
  sitesurl.each do |site|
    ar = Array.new
    site.each { |key, value| ar << value }
    csv << ar
  end
end

print '[DONE]' + "\n"
