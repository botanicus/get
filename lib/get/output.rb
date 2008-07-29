class Output
  def wget(filename)
    File.open(filename, "w") do |file|
      file.puts("#!/bin/bash\n\n")
      @urls.each do |url|
        file.puts("wget '#{url}'")
      end
    end
  end
end