#!/usr/bin/env ruby
# coding=utf-8

=begin rdoc
  url_collector [params] [pages]
  --pdf
  -t --to [download dir]
=end

require "optparse"
require "page"

@page = Page.new

options = { :default => "args" }

ARGV.options do |opts|
  opts.banner = "Usage: #{File.basename($0)} [options] [pages]"
  
  opts.separator ""
  opts.separator "Specific Options:"
  opts.on( "-e", "--extension", String,
           "Download just [filetype]." ) do |opt|
    @page.extensions.push(opt)
  end
  # specials for: --pdf, --music, --movies
  
  
  
  opts.separator "Common Options:"
  
  opts.on( "-h", "--help",
           "Show this message." ) do
    puts opts
    exit
  end
  
  begin
    opts.parse!
  rescue
    puts opts
    exit
  end

end
