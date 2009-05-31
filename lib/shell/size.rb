require "active_support"
# require File.dirname(__FILE__) + "/errors"
# TODO: it will be external library

class Size
  def initialize(integer, unit)
    @unit   = unit.upcase
    @method = recognize_unit(unit)
    @size   = integer.send(@method)
  end
  
  def to_i
    return @size
  end
  
  private
  def recognize_unit(unit)
    case unit
    when "KB" then :kilobyte
    when "MB" then :megabyte
    when "GB" then :gigabyte
    else raise ::UnknownUnit.new(unit)
    end
  end
end