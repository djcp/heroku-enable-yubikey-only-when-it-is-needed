require 'fileutils'
class Heroku::Auth
  class << self
    alias_method :_orig_ask_for_second_factor, :ask_for_second_factor
    def ask_for_second_factor
      result = _orig_ask_for_second_factor
      file = File.expand_path('~/.heroku/yubipresses.log')
      FileUtils.touch file
      open(file, 'a') { |f| f.puts Time.now.utc.to_s }
      result
    end
  end
end
