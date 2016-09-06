#!/usr/bin/env ruby1.8
# coding=utf-8

=begin rdoc
  page [params] [pages]
  --pdf
  -t --to [download dir]
=end

# TODO: base = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
require "optparse"
require "rdoc/usage"
require "easyruby/core/unique_array"
require "get/page"
require "get/uri"
require "get/log"
require "get/option_parser"
require "get/mime_types"
require "shell/size"
require "shell/option_parser"

# Default OPTS
OPTS = {
  :extensions => Array.new,
  :recursive  => false,
  :protocols  => ["http"],
  :flatten    => false,
  :verbose    => true }

site = ARGV.shift
abort("Any parameters given. Type -h for help.") unless site
@page = Page.new(site)

ARGV.options do |opts|
  opts.banner = "Usage: #{File.basename($0)} [site] [options]"
  
  # MIME-types options
  opts.separator "MIME-types options:"
  opts.on("-e", "--extensions", Array, "Download just files with given extensions.") do |exts|
    page[:extensions].push(*exts)
  end

  opts.on( "-m", "--mime", Array,
           "Download just files with given MIME-type (Example: #{$0}) localhost:3300 --mime text/html" ) do |opt|
    
  end

  %w{ pdf js css js }.each do |extension|
    opts.extension(extension) do
      OPTS[:extensions].push(extension)
    end
  end
  
  # General types
  opts.on("-M", "--movies", "Download just movies.") do
   OPTS[:extensions].push("movies")
  end
  opts.on("-I", "--images", "Download just images.") do
    OPTS[:extensions].push("images")
  end
  opts.on("-A", "--rss", "Extract RSS and Atom links") do
    OPTS[:extensions].push("feeds")
  end
  
  # Protocol options
  opts.separator "Protocol options:"
  opts.on("-S", "--svn", "Extract SVN links.") do
    OPTS[:protocols].push("svn")
  end
  opts.on("-G", "--git", "Extract Git links.") do
    OPTS[:protocols].push("git")
  end
  opts.on("-F", "--ftp", "Extract FTP links.") do
    OPTS[:protocols].push("ftp")
  end
  opts.on("-P", "--protocol", Array, "Use these protocols") do
    OPTS[:extensions].push("feeds")
  end
  
  # Output options
  opts.separator "Output options:"
  opts.on("-w", "--wget", "Output will be Bash script using wget.") do
    OPTS[:output] = "wget"
  end
  opts.on("-d", "--download", "Download the files.") do
    OPTS[:output] = "download"
  end
  
  opts.on( "-f", "--flatten", "Create flatten structure." ) do
    OPTS[:flatten] = true
  end
  
  # Size options
  opts.separator "Size options:"
  opts.on( "-s", "--size", Range, "Size from x to y. (Example: 20..40KB or 100KB..10MB)" ) do |opt|
    OPTS[:size] = opt
  end

  opts.on( "-xs", "--max-size", Size, "Max size" ) do |opt|
    OPTS[:size] = 0..opt
  end
  
  opts.on( "-ns", "--min-size", Size, "Min size" ) do |opt|
    n = 1.0 / 0 # Infinity
    OPTS[:size] = opt..n
  end
  
  # General options
  opts.separator "General options:"
  opts.on("-R", "--recursive", "Recursive proceed.") do
    OPTS[:recursive] = true
  end
  # --t --types: show all mimes at site
  
  opts.on("-M", "--match", Regexp, "Use just links which match given regexp.") do |opt|
    @page.urls.reject! { |url| not url.match(opt) }
  end
  
  opts.on("-pm", "--print-mimes", "Print all MIME types on the site.") do
    OPTS[:show] = :mimes
  end
  
  opts.on("-q", "--quiet") do
    OPTS[:verbose] = false
  end
  
  opts.on("-p", "--pretend", "Just pretend.") do
    OPTS[:pretend] = true
  end
  
  opts.on("-d", "--debug", "Debug on.") do
    OPTS[:debug] = true
  end
  
  opts.separator "Common options:"
  opts.on("-h", "--help", "Show this message.") do
    abort(opts.to_s)
  end
  
  # help if
  opts.parse! #rescue abort(opts.to_s)
end

require File.dirname(__FILE__) + "/../lib/get/runner"

__END__
# ====================
# = DEVELOPMENT ONLY =
# ====================
@page = Page.new(ARGV.first || "http://localhost:3300")
@page.proceed
puts "Linky, co nejsou na hlavni strance:"
puts @page.recursive - @page.urls
# puts @page.urls
