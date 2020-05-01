require_relative './parse_import_statement'

class TreeResult < Struct.new(:tree)
  def to_h
    {
      node: tree.fetch(:node),
      children: tree.fetch(:children).map(&:to_h)
    }
  end
end

class TreeBuilder < Struct.new(:entrypoint)
  def self.call entrypoint
    new(entrypoint).call
  end

  def call
    TreeResult.new({
      node: entrypoint,
      children: _call
    })
  end

  private

  def _call
    File.open(entrypoint).each_line.map do |line|
      ParseImportStatement.call(line)
    end
      .select {|l| path? l }
      .map do |l|
        [
          add_file_extension(to_absolute_path(l).gsub(Dir.pwd, ''), '.js'),
          add_file_extension(to_absolute_path(l).gsub(Dir.pwd, ''), '.jsx'),
        ]
      end
        .map {|paths| to_real_path paths }
        .map {|path| TreeBuilder.call('.' + path) }
  end

  def add_file_extension(path, extension)
    return path if !File.extname(path).empty?
    path + extension
  end

  def path? line
    line.include? '.'
  end

  def to_absolute_path line
    File.expand_path("#{File.dirname(entrypoint)}/#{line}").to_s
  end

  def to_real_path paths
    paths.find {|path| File.exists?(File.expand_path(Dir.pwd + path)) }
  end
end
