require './lib/tree_builder'

describe TreeBuilder do
  it 'builds a tree' do
    entry = './fixtures/app.jsx'
    result = TreeBuilder.call(entry)

    expect(result.to_h).to eq({
      node: entry,
      children: [
        {
          node: "./fixtures/foo.js",
          children: [],
        },
        {
          node: "./fixtures/bar.js",
          children: [],
        },
        {
          node: "./fixtures/baz/baz.js",
          children: [
            {
              children: [],
              node: "./fixtures/ku.js"
            }
          ]
        },
        {
          node: "./fixtures/image.png",
          children: []
        }
      ]
    });
  end
end
