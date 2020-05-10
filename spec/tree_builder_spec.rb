require './lib/tree_builder'

describe TreeBuilder do
  it 'builds a tree' do
    entry = 'fixtures/app.jsx'
    result = TreeBuilder.call(entry)

    expect(result.to_h).to eq({
      entry => {
        abs("/fixtures/foo.js") => {},
        abs("/fixtures/bar.js") => {},
        abs("/fixtures/baz/baz.js") => {
          abs("/fixtures/ku.js") => {}
        },
        abs("/fixtures/image.png") => {},
        abs("/fixtures/style.less") => {
          abs("/fixtures/other-style.less") => {},
          abs("/fixtures/image.png") => {}
        }
      }
    });
  end

  def abs path
    "#{Dir.pwd}#{path}"
  end
end
