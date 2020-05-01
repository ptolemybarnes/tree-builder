require './lib/import_statement'

RSpec::Matchers.define :parse do |expected|
  match do |actual|
    !ImportStatement.new(actual).location.empty?
  end
  failure_message do
    "expected \"#{actual}\" would parse to a result, but it was empty"
  end
end


describe ImportStatement do

  it 'works, like, really well' do
    File.open('./spec/examples/import_statement_examples.txt').each_line do |example|
      input = example.strip
      next if input.empty?
      result = ImportStatement.new(input).location
      expect(input).to parse
      expect(result).not_to include ';'
    end
  end

  it 'parses a relatve file import' do
    expect(ImportStatement.new("import bar from './foo/bar.js'").location).to eq './foo/bar.js'
  end

  it 'parses an absolute file import' do
    expect(ImportStatement.new("import bar from '/foo/bar.js'").location).to eq '/foo/bar.js'
  end
end
