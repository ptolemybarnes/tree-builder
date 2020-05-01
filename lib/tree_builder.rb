require 'set'
require_relative './parse_import_statement'

class TreeResult < Struct.new(:tree)
  def to_h
    {
      node: tree.fetch(:node),
      children: tree.fetch(:children).map(&:to_h)
    }
  end
end

PARSABLE_FILE_TYPES = Set['.jsx', '.js']

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
    puts "Traversed file: #{entrypoint}"
    raise e
  end

  private

  def _call
    open_file(entrypoint).map do |line|
        ParseImportStatement.call(line)
    end
      .select {|l| path? l }
      .map do |path|
        PARSABLE_FILE_TYPES.map {|filetype| add_file_extension(to_absolute_path(path).gsub(Dir.pwd, ''), filetype) }
      end
        .map {|paths| to_real_path paths }
        .map {|path| TreeBuilder.call('.' + path) }
  end

  def open_file path
    extname = File.extname(path)
    if !PARSABLE_FILE_TYPES.include? extname
      return []
    end
    File.open(path).each_line
  end

  def add_file_extension(path, extension)
    return path if !File.extname(path).empty?
    path + extension
  end

  def path? line
    line.start_with?('.') || line.start_with?('/')
  end

  def to_absolute_path line
    File.expand_path("#{File.dirname(entrypoint)}/#{line}").to_s
  end

  def to_real_path paths
    paths.find {|path| File.exists?(File.expand_path(Dir.pwd + path)) }
  end
end
