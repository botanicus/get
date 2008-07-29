require "uri"

class URI::Generic
  attr_writer :content_type
  def same_host?(uri)
    # When you use just self.host.eql?(uri.host),
    # it won't work for www.botablog.cz vs. botablog.cz
    # FIXME: foo.co.uk
    regexp = Regexp.new(/([^\.]+\.\w{2,4})$/)
    uri.host.to_s[regexp, 1] == self.host.to_s[regexp, 1]
  end
  
  def content_type
    return @content_type if @content_type
    begin
      Net::HTTP.start(self.host, self.port || 3300) do |http| # fixme: 80
        return http.head(self.path).content_type
      end
    rescue SocketError
      puts "Skipping: #{self.path}"
    end
  end
end