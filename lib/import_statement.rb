class ImportStatement
  attr_reader :location

  NULL_IMPORT_STATEMENT = [nil, '']

  def initialize line
    _, location = (line.chomp.match(/import.*from '(.*)'/) do |match|
      [nil, match[1].gsub(/[\'|;]/, '')]
    end || NULL_IMPORT_STATEMENT)
    @location = location
    @name = _
  end

  def file_import?
    # if the location referenced by an import statement does not start with '.' or '/',
    # we assume that it's a package import.
    location.start_with?('.') || location.start_with?('/')
  end
end
