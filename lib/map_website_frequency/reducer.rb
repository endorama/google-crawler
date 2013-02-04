
current_word = nil
current_count = 0
word = nil

# input comes from STDIN
ARGF.each do |line|
  # remove leading and trailing whitespace and \n
  line = line.strip.chomp.gsub(/"/, '')

  # parse the input we got from mapper.py
  word, count = line.split("\\t")

  # convert count (currently a string) to int
  begin
    count = count.to_i
  rescue Exception => e
    # count was not a number, so silently ignore/discard this line
    next
  end
  
  # this IF-switch only works because Hadoop sorts map output
  # by key (here: word) before it is passed to the reducer
  if current_word == word
    current_count += count
  else
    if current_word
      # write result to STDOUT
      print "#{current_word}, #{current_count}\n"
    end
    
    current_count = count
    current_word = word
  end
end

# do not forget to output the last word if needed!
if current_word == word
  print "#{current_word}, #{current_count}\n"
end
