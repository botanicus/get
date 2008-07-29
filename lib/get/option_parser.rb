class OptionParser
  def extension(extension, &block)
    self.on("--#{extension}", "Use just #{extension.upcase} files.")
    block.call if block_given?
  end

  alias __separator separator
  def separator(description)
    __separator ""
    __separator description
  end
end