require File.dirname(__FILE__) + "/../lib/get/EasyRuby::Unique_array"
require File.dirname(__FILE__) + "/spec_helper"

describe EasyRuby::UniqueArray do
  before(:each) do
    @array = EasyRuby::UniqueArray.new
    @array.push(1, 2, 3, 4, 5)
  end

  it "every item should be EasyRuby::Unique" do
    lambda { @array.push(1) }.should_not change(@array, :length).by(1)
  end
end