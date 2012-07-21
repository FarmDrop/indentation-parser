require 'indentation-parser'
require 'ostruct'

describe IndentationParser do
  it "does what is written in the readme" do
    parser = IndentationParser.new do |p|
      p.default do |parent, source|
        node = OpenStruct.new
        parent.send("#{source}=", node)
        node
      end
      p.on /([^ ]+) : (.+)/ do |parent, source, captures|
        node = captures[2]
        parent.send("#{captures[1]}=", node)
        node
      end
    end

    source = IO.read("spec/material/an.example")
    
    output = parser.read(source, OpenStruct.new).value

    output.this.is.an.example.should eq "First example"
    output.this.is.the.second.one.should eq "Second example"
    output.this.serves.as.another.example.should eq "Third example"
  end
end