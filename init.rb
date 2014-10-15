require 'fileutils'
class Heroku::Auth
  class << self
    alias_method :_orig_ask_for_second_factor, :ask_for_second_factor
    def ask_for_second_factor
      dialog = `osascript -e 'tell app "System Events" to display dialog "Two Factor:" default answer "" with icon 1 with hidden answer buttons "ugh" default button 1'`
      match = dialog.match(/text returned:(\w+)/)

      @two_factor_code = match && match[1]
      @api=nil

      file = File.expand_path('~/.heroku/yubipresses.log')
      FileUtils.touch file
      open(file, 'a') { |f| f.puts Time.now.utc.to_s }

      @two_factor_code
    end
  end
end
