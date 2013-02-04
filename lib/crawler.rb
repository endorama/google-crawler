require 'nokogiri'
require 'open-uri'

def load_stop_words
  stop_words = Array.new
  italian_stop_words = File.readlines("utils/stop_words/italian.txt").each { |line| line.chomp!.strip! }
  generic_stop_words = File.readlines("utils/stop_words/generic.txt").each { |line| line.chomp!.strip! }
  stop_words = stop_words.concat(italian_stop_words).concat(generic_stop_words)
end

def get_word_frequencies(url, stop_words)
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
    # Remove <script>…</script>
    site.css('script').remove                          
    # Remove on____ attributes   
    site.xpath("//@*[starts-with(name(),'on')]").remove
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
    print "\n" + '[ERROR] Cannot retrieve URL for processing: ' + e.to_s + " #{url}" + "\n"
  rescue Exception => e
    print "\n" + '[ERROR] Some error happened: ' + e.to_s + "\n"
  end

  keywords
end
