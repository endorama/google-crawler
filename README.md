A little script to parse google search pages and retrieve all the results.

The results are saved in csv format inside the `scraped/` folder.
CSV headers are:

```
url => the URL of the result ( aka website URL )
title => the title of the result ( aka website page title )
google_page => the google page number the results was found in
google_position => the absolute position in the google results of the result
keywords => the 10 words more used on the page ( got by parsing the whole <body> of the page and applying a word frequency algorightm )
```

Tested using ruby 1.9.3

Some reference used to build the project:

http://ruby.bastardsbook.com/chapters/html-parsing/
http://ruby.bastardsbook.com/chapters/web-crawling/
http://ruby.bastardsbook.com/chapters/mechanize/

Tutorial: Writing a Word Frequencies Script in Ruby
http://semantichumanities.wordpress.com/2006/02/21/word-frequencies-in-ruby-tutorial/
