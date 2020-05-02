require './lib/tree_builder'

describe TreeBuilder do
  it 'builds a tree' do
    entry = 'fixtures/app.jsx'
    result = TreeBuilder.call(entry)

    expect(result.to_h).to eq({
      node: entry,
      children: [
        {
          node: abs("/fixtures/foo.js"),
          children: [],
        },
        {
          node: abs("/fixtures/bar.js"),
          children: [],
        },
        {
          node: abs("/fixtures/baz/baz.js"),
          children: [
            {
              children: [],
              node: abs("/fixtures/ku.js")
            }
          ]
        },
        {
          node: abs("/fixtures/image.png"),
          children: []
        }
      ]
    });
  end

  def abs path
    "#{Dir.pwd}#{path}"
  end
end
