require './lib/parse_import_statement'

RSpec::Matchers.define :extract do |expected|
  match do |actual|
    !ParseImportStatement.call(actual).empty?
  end
  failure_message do
    "expected input would parse to a result, but it was empty"
  end
end


describe ParseImportStatement do

  it 'works, like, really well' do
    File.open('./spec/examples/import_statement_examples.txt').each_line do |example|
      input = example.strip
      next if input.empty?
      result = ParseImportStatement.call(input)
      expect(input).to extract
      expect(result).not_to include ';'
    end
  end
end
