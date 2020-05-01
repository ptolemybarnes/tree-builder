class ParseImportStatement
  def self.call line
    line.chomp.match(/import.*from (.*)/) do |m|
      m[1].gsub(/[\'|;]/, '')
    end || ''
  end
end
