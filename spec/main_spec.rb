require './lib/tree_builder'

describe 'main' do
  it '' do
    result = TreeBuilder.call('./fixtures/app.jsx')

    expect(result).to eq([
      './fixtures/foo.js'
    ]);
  end
end
