require "net/http"

PERMITTED_TYPES = %{text/html application/xml+xhtml }
Net::HTTP.start("localhost", 3300) do |http|
	# raise exception on redirect
	begin
		response = http.head("/")
	rescue # XXX
	end
	unless PERMITTED_TYPES.include?(response.content_type)
	end
end