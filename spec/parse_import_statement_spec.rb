require './lib/parse_import_statement'

RSpec::Matchers.define :parse do |expected|
  match do |actual|
    !ParseImportStatement.call(actual).empty?
  end
  failure_message do
    "expected \"#{actual}\" would parse to a result, but it was empty"
  end
end


describe ParseImportStatement do

  it 'works, like, really well' do
    File.open('./spec/examples/import_statement_examples.txt').each_line do |example|
      input = example.strip
      next if input.empty?
      result = ParseImportStatement.call(input)
      expect(input).to parse
      expect(result).not_to include ';'
    end
  end

  it 'parses a relatve file import' do
    expect(ParseImportStatement.call("import bar from './foo/bar.js'")).to eq './foo/bar.js'
  end

  it 'parses an absolute file import' do
    expect(ParseImportStatement.call("import bar from '/foo/bar.js'")).to eq '/foo/bar.js'
  end
end
