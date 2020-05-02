
class ImportStatement
  attr_reader :location, :location_reference, :name

  NULL_IMPORT_STATEMENT = [nil, '']

  def initialize line, location_reference = ''
    _, location = (parse(line) || NULL_IMPORT_STATEMENT)
    @location = location
    @location_reference = location_reference
    @name = _
  rescue Exception => e
    raise ImportStatementParseException.new("Error parsing: #{line} of file: '#{location_reference}'", e)
  end

  def parse line
    line.chomp.match(/((} from)|(^import)|(React.lazy)).*'(.*)'/) do |match|
      [nil, match[5].gsub(/[\'|;]/, '')]
    end
  end

  def file_import?
    # if the location referenced by an import statement does not start with '.' or '/',
    # we assume that it's a package import.
    location.start_with?('.') || location.start_with?('/')
  end

  def to_s
    "#<ImportStatement:#{object_id} @location='#{location}', @name='#{name}', @reference='#{location_reference}', file_import?=#{file_import?}>"
  end

  class ImportStatementParseException < RuntimeError; end
end
