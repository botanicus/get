class UnknownUnit < StandardError
  def initialize(unit)
    @unit = unit
  end
  
  def message
    "Unknown unit: #@unit (#{@unit.class})"
  end
end