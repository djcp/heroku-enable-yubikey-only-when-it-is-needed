require 'fileutils'
require 'mkmf'

class Heroku::Auth
  class << self
    alias_method :_orig_ask_for_second_factor, :ask_for_second_factor
    def ask_for_second_factor
      if RUBY_PLATFORM.include? "linux"
        if find_executable "yubitoggle"
          `yubitoggle --on`
        else
          `yubiswitch on`
        end
      elsif RUBY_PLATFORM.include? "darwin"
        `osascript -e 'tell application "yubiswitch" to KeyOn'`
      end
      result = _orig_ask_for_second_factor
      if RUBY_PLATFORM.include? "linux"
        if find_executable "yubitoggle"
          `yubitoggle --off`
        else
          `yubiswitch off`
        end
      elsif RUBY_PLATFORM.include? "darwin"
        `osascript -e 'tell application "yubiswitch" to KeyOff'`
      end
      file = File.expand_path('~/.heroku/yubipresses.log')
      FileUtils.touch file
      open(file, 'a') { |f| f.puts Time.now.utc.to_s }
      result
    end
  end
end
