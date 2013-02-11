require 'uri'

def is_uri?(string)
  uri = URI.parse(string)
  %w( http https ).include?(uri.scheme)
rescue URI::BadURIError
  false
rescue URI::InvalidURIError
  false
end

require 'logger'

$LOG = Logger.new(STDOUT)

$LOG.level = Logger::WARN

$LOG.formatter = proc { |severity, datetime, progname, msg|
  case severity
  when 'DEBUG'
    spaciator = "    *"
  when 'INFO'
    spaciator = "   **"
  when 'WARN'
    spaciator = "  ***"
  when 'ERROR'
    spaciator = " ****"
  when 'FATAL'
    spaciator = "*****"
  else
    spaciator = "     "
  end

  print " #{spaciator} [#{severity}] [#{datetime}] -- #{msg}\n"
}
