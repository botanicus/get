require File.dirname(__FILE__) + "/../lib/get/uri"
require File.dirname(__FILE__) + "/spec_helper"

describe URI::Generic do
  before(:each) do
    @uris = %w{http://botablog.cz http://www.botablog.cz http://root.cz}
    @uris.map! { |uri| URI.parse(uri) }
  end

  it "should be from same host if it has different subdomain" do
    @uris[0].should be_same_host(@uris[1])
  end
  
  it "should not be from the same host when it isn't" do
    @uris[0].should_not be_same_host(@uris[2])
  end
end