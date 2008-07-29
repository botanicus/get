require "pathname"
require File.dirname(__FILE__) + "/../lib/get/uri"
require File.dirname(__FILE__) + "/spec_helper"

def run(args)
  
end

describe URI::Generic do
  before(:each) do
    @script = Pathname(__FILE__).dirname.parent + "/bin/get.rb"
    run = lambda { |args| %x{ruby --pretend #{@script}} }
  end
  
  it "should be quit if -q or --quite" do
    run.call("-q")
  end
end