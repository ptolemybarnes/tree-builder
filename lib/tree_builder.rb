require 'set'
require_relative './import_statement'

class TreeResult < Struct.new(:tree)
  def to_h
    {
      node: tree.fetch(:node),
      children: tree.fetch(:children).map(&:to_h)
    }
  end
end

PARSABLE_FILE_TYPES = Set['.jsx', '.js']

class ImportStatementParseException < RuntimeError; end

class TreeBuilder < Struct.new(:entrypoint)
  def self.call entrypoint
    new(entrypoint).call
  end

  def call
    TreeResult.new({
      node: entrypoint,
      children: _call
    })
  rescue Exception => e
    STDERR.puts "Traversed file: #{entrypoint}"
    raise e
  end

  private

  def _call
    read_file(entrypoint)
      .map.with_index do |line, idx|
        line_number = idx + 1
        STDERR.puts "processing #{entrypoint}:#{line_number}"
        ImportStatement.new(line, "#{entrypoint}:#{line_number}")
      rescue Exception => error
        raise ImportStatementParseException.new("Error parsing: #{line} of file: #{entrypoint}:#{line_number}", error)
      end
      .select(&:file_import?)
      .map do |path|
        PARSABLE_FILE_TYPES.map {|filetype| add_file_extension(to_absolute_path(path.location).gsub(Dir.pwd, ''), filetype) }
      end
      .map {|paths| paths.map {|path| '.' + path }}
      .map {|paths| to_real_path paths }
      .map {|path| TreeBuilder.call(path) }
  end

  def read_file path
    return [] if !PARSABLE_FILE_TYPES.include? File.extname(path)
    File.open(path).each_line
  end

  def add_file_extension(path, extension)
    return path if !File.extname(path).empty?
    path + extension
  end

  def to_absolute_path line
    File.expand_path("#{File.dirname(entrypoint)}/#{line}").to_s
  end

  def to_real_path paths
    real_path = paths.find {|path| File.exists?(path) }
    return real_path if real_path
    raise RuntimeError.new("Unable to reduce to a real path: #{paths.join(', ')} when parsing #{entrypoint}")
  end
end
