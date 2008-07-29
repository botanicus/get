require "open-uri"
require "net/http"
require "mime/types"
require "uri"

# TODO: Rewrite it for net/http etc, authentication and content_type
class Page
  attr_accessor :extensions # array
  attr_accessor :directory  # string
  attr_accessor :match      # regexp || nil
  attr_accessor :urls
  attr_accessor :url
  PERMITTED_MIMES = %w{text/html application/xml+xhtml}

  def initialize(url) # http://www.root.cz or just www.root.cz
    @@visited ||= UniqueArray.new
    url = url.match(/^\w+:\/{2}/) ? url : "http://#{url}"
    @url = URI.parse(url)
    @@urls ||= UniqueArray.new
    @extensions = Array.new
    @directory  = File.join(ENV["HOME"], "Downloads")
    @schemes = %{http https ftp ftps svn git}
    @@http ||= Net::HTTP.start(@url.host, @url.port || 80)
    begin @page = open(@url.to_s).read #; puts "Have it: #{@url.to_s}"
    rescue Errno::ENOENT
      abort "Check you internet connection and try it again please!"
    # rescue OpenURI::HTTPError
    end
  end
  
  def urls
    @@urls
  end
  
  def proceed
    # Changed @urls to @@urls
    @@urls = URI.extract(@page)
    @@urls.map! { |url| URI.parse(url) rescue nil }.compact!
    @@urls.reject! { |url| not @schemes.include?(url.scheme) }
    return self
  end
  
  def urls_with_given_extensions
    return @@urls if @extensions.empty? # ch
    return @@urls.find_all do |url|     # ch
      extension = url[/\.\w{1,4}$/, 1]
      @extensions.include?(extension)
    end
  end
  
  def each(&block)
    self.recursive.each do |url|
      block.call(url) if block_given?
    end
  end

  # autentizace
  def recursive
    self.proceed
    result = UniqueArray.new
    @@urls.each do |url| # ch
      next unless url.same_host?(@url)
      puts "#{@@urls.index(url)} of #{@@urls.length}" # ch 2
      begin
        result << proceed_recursive(url)
      rescue OpenURI::HTTPError
        if $!.message.eql?("404 Not Found")
          puts("Skipped: #{url}")
          next
        else
          raise $!
        end
      end
    end
    return result.sort
  end
  
  private
  def proceed_recursive(url)
  # just from this domain
    page = self.class.new(url.to_s)
    page.proceed
    # Why 2 unless? is_html_or_xml is quite narocne on procak
    # We want continue only if url is not in @@visited and if url's content type is HTML or XML
    @@visited.push(page.url)
    @@urls.push(*page.urls)
    unless @@visited.include?(url)
      if html_or_xml?(url)
        proceed_recursive(url)
      end
    end
    return @@urls
  end
  
  def html_or_xml?(url)
    # FIXME: Net::HTTP with block is BAD idea! @@http is better
    STDERR.print("Checking content type of #{url.route_from(@url)} ...")
    # STDERR.print("Checking content type of #{url.route_from(@url).path} ...")
    response = @@http.head(url.route_from(@url).to_s)
    result = PERMITTED_MIMES.include?(response.content_type)
    url.content_type = response.content_type ### need to use
    STDERR.puts "#{result} (#{response.content_type})"
    return result
  end
  # def html_or_xml?(url)
  #   # FIXME: Net::HTTP with block is BAD idea! @@http is better
  #   STDERR.print("Checking content type of #{url.route_from(@url)} ...")
  #   # STDERR.print("Checking content type of #{url.route_from(@url).path} ...")
  #   Net::HTTP.start(@url.host, @url.port || 80) do |http|
  #     response = http.head(url.route_from(@url).to_s)
  #     result = PERMITTED_MIMES.include?(response.content_type)
  #     url.content_type = response.content_type ### need to use
  #     STDERR.puts "#{result} (#{response.content_type})"
  #     return result
  #   end
  # end
  
  def check(url)
    @extensions.any? do |extension|
      url.match(/^.+\.#{extension}$/)
    end
  end
end