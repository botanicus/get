require "open-uri"
require "uri"

class Page

  attr_accessor :extensions # array
  attr_accessor :directory  # string
  attr_accessor :match      # regexp || nil
  
  def initialize(url) # http://www.root.cz or just www.root.cz
    @url = url.match(/^\w+:\/{2}/) ? url : "http://#{url}"
    @extensions = Array.new
    @directory  = File.join(ENV["HOME"], "Downloads")
    begin @page = open(@url) { |page| page.readlines }
    rescue Errno::ENOENT
      puts "Check you internet connection and try it again please!"
    end
  end
  
  def proceed
    @urls = URI.extract(@page)
    # relative URLS
    @urls.collect { |url| "#@url/#{url}" unless url.match(/^\w+:\/{2}/) }
  end
  
  def filter
    @urls.collect { |url| url if check(url) }.compact
  end
  
  private
  
  def check(url)
    @extensions.any? do |extension|
      url.match(/^.+\.#{extension}$/)
    end
  end

end