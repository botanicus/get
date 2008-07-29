# Recursive
output = UniqueArray.new
if OPTS[:recursive]
  log("Recursive ...")
  output.push(*@page.recursive)
else
  log("Not recursive ...")
  output.push(*@page.proceed.urls)
end

# Protocols
log("Choosen protocols: #{OPTS[:protocols].join(", ")}")

# Show MIME types
if OPTS[:show].eql?(:mimes)
  output.map! { |site| site.content_type }.uniq!
else
  OPTS[:protocols].each do |protocol|
    unless OPTS[:extensions].empty?
      OPTS[:extensions].each do |extension|
        case extension
        when "pdf"
        when "images"
        when "js"
          output.map! do |url|
            if url # nekdy je false, proc?
              # p url.content_type # OK
              begin
                if MIMES[:js].include?(url.content_type)
                  url#.content_type
                end
              rescue
                nil
              end
            end
          end
        end
      end
      output
    end
  end  
end

case OPTS[:output]
when "wget"
when "download"
else
end

puts output.compact ###