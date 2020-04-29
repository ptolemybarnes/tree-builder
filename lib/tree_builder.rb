class TreeBuilder
  def self.call(entrypoint)
    File.open(entrypoint).each_line.map do |line|
      line.chomp.match(/import.*from (.*)/)[1].gsub('\'', '')
    end
  end
end
