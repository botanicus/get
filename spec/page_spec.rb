require File.dirname(__FILE__) + "/../lib/page"
require File.dirname(__FILE__) + "/../lib/uri"

describe Page do
  before(:each) do
    @page = Page.new("http://localhost:3300")
    @page.proceed
  end

  describe "#proceed" do
    it "should collect all URLs from page" do
      @page.urls.should be_kind_of(Array)
      @page.urls.each { |url| url.should be_kind_of(URI::Generic) }
    end
  end
  
  describe "#recursive" do
    before(:each) do
      @all = @page.recursive
    end
    it "should go throw all the pages at given domain" do
      @all.should be_kind_of(Array)
      @all.each { |url| url.should be_kind_of(URI::Generic) }
    end
  end
end