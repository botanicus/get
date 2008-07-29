# 10MB
OptionParser.accept(Size, /(\d+)(\w+)/) do |all, integer, unit|
  Size.new(integer.to_i, unit).to_i
end

# 10-30KB
OptionParser.accept(Range, /(\d+)\.{2}(\d+)(\w+)/) do |all, min, max, unit|
  min = Size.new(min.to_i, unit)
  max = Size.new(max.to_i, unit)
  min.to_i..max.to_i
end

# 100KB-30MB
OptionParser.accept(Range, /(\d+)(\w+)\.{2}(\d+)(\w+)/) do |all, min, minunit, max, maxunit|
  min = Size.new(min.to_i, minunit)
  max = Size.new(max.to_i, maxunit)
  min.to_i..max.to_i
end