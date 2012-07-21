require 'indentation-parser'

describe IndentationParser do
  it "parses indented files" do
    parser = IndentationParser.new do |p|
      p.default do |parent, source|
        node = {}
        parent[source.to_sym] = node
        node
      end
      
      p.on_leaf do |parent, source|
        parent[:leafs] = Array.new  unless parent[:leafs]
        parent[:leafs] << source
        source
      end
    end
    
    source = IO.read("spec/material/test.mylang")
    
    result = parser.read(source, {}).value
    
    expected_hash = {
      :this => {
        :is => {
          :crazy => {
            :leafs => ["and"]
          }
        },
        :leafs => ["structure", "weird"]
      },
      :and => {
        :does => {
          :not => {
            :leafs => ["make"]
          },
          :leafs => ["any"]
        },
        :leafs => ["sense"]
      }
    }
    
    result.should eq expected_hash
  end  
end