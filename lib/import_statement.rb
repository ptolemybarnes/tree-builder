
class ImportStatement
  attr_reader :location, :location_reference

  NULL_IMPORT_STATEMENT = ''

  def initialize line, location_reference = ''
    location = (parse(line) || NULL_IMPORT_STATEMENT)
    @location = location
    @location_reference = location_reference
  rescue Exception => e
    raise ImportStatementParseException.new("Error parsing #{line} of file: '#{location_reference}': #{e.message}")
  end

  def parse line
    line.chomp.match(/((} from)|(^@?import)|(url\()|(React.lazy)).*['"](.*)['"]/) do |match|
      match[6].gsub(/[\'|;]/, '')
    end
  end

  def file_import?
    # if the location referenced by an import statement does not start with '.' or '/',
    # we assume that it's a package import.
    location.start_with?('.') || location.start_with?('/')
  end

  def to_s
    "#<ImportStatement:#{object_id} @location='#{location}', @reference='#{location_reference}', file_import?=#{file_import?}>"
  end

  class ImportStatementParseException < RuntimeError; end
end
