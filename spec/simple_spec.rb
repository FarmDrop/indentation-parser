require 'indentation-parser'

describe IndentationParser do
  it "parses indented files" do
    parser = IndentationParser.new do |p|
      p.default do |parent, indentation, source|
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
    
    source = IO.read("spec/material/test.mylang")
    
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
  end  
end