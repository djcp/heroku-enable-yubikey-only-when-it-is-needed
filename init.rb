require 'fileutils'
class Heroku::Auth
  class << self
    alias_method :_orig_ask_for_second_factor, :ask_for_second_factor
    def ask_for_second_factor
      dialog = `osascript -e 'tell app "System Events" to display dialog "Two Factor:" default answer "" with icon 1 with hidden answer buttons "ugh" default button 1'`
      result = dialog.match(/text returned:(\w+)/)[1]
      file = File.expand_path('~/.heroku/yubipresses.log')
      FileUtils.touch file
      open(file, 'a') { |f| f.puts Time.now.utc.to_s }
      result
    end
  end
end
