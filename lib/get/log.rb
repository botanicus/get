module Kernel
  def log(message)
    if defined?(OPTS)
      if OPTS[:verbose]
        STDERR.puts(message)
      end
    end
  end
end