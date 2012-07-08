require 'indentation-parser'

describe IndentationParser do
  it 'parses indented files' do
    parser = IndentationParser.new do |p|
      p.else do |parent, indentation, source|
        node = {}
        parent[source.to_sym] = node
        node
      end
      
      p.on_leaf do |parent, indentation, source|
        node = {}
        parent[source.to_sym] = node
        node
      end
    end
    
    source = IO.read("spec/test.mylang")
    
    result = parser.read(source, {}).value
    
    expected_hash = {
      :this => {
        :structure => {},
        :is => {
          :crazy => {
            :and => {}
          }
        },
        :weird => {}
      },
      :and => {
        :does => {
          :not => {
            :make => {}
          },
          :any => {}
        },
        :sense => {}
      }
    }
    
    result.should eq expected_hash
    
    puts result
  end
end