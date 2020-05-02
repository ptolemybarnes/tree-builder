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

  it 'parses lazy imports' do
    import_statement = "export const MyLazyComponent = React.lazy(() => import(/* webpackChunkName: \"MyLazyComponent\" */'../My/Lazy/Component.jsx'));"

    expect(ImportStatement.new(import_statement).location).to eq '../My/Lazy/Component.jsx'
  end

  it 'parses the end of multiline statements' do
    multiline_import_end = " } from '../../foo/bar.js';"

    expect(ImportStatement.new(multiline_import_end).location).to eq '../../foo/bar.js'
  end

  it "does not get confused by strings with 'from' in" do
    input = "throw new Error(`The attribute was missing from the foo-bar: ${path.join('.')}`);"

    expect(ImportStatement.new(input)).to_not be_file_import
  end

  it "does not get confused by strings with 'import' in" do
    input = "throw new Error(`The import was missing from the foo-bar: ${path.join('.')}`);"

    expect(ImportStatement.new(input)).to_not be_file_import
  end

  # xit "doesnt misinterpret strings that describe import statements (not needed for now)" do
  #   expect(ImportStatement.new("\"import bar from '/foo/bar.js'\"").location).to eq ''
  # end
end
