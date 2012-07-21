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


# ##### First block

# ```ruby
# p.default do |parent, indentation, source|
#   node = OpenStruct.new
#   parent.send("#{source}=", node)
#   node
# end
# ```

# This defines what the parser does with a line of code when no other hook is defined. The
# parameters you get from the parser inside your block are:

# - The `parent` node. This is the object you have set for an already parsed line.
# - The `source`, basically the whole line the parser currently evaluates without indentation.

# *Now, step by step:*

# We define a new `OpenStruct` instance and store it in a variable called `node`.

# Since we know that all parent objects are going to be `OpenStruct`s too, we set an attribute on
# it. The name of the attribute is given by the `source` parameter.

# Last but not least, we return the node. **This is very important!** In 
# order to be able to pass the `parent` parameter to the block, the parser maintains an internal
# node structure. Only if you pass the node as a return value, the parser can store it there!

# ##### Second block

# ```ruby
# p.on /([^ ]+) : (.+)/ do |parent, indentation, source, captures|
#   node = captures[2]
#   parent.send("#{captures[1]}=", node)
#   node
# end
# ```

# The regular expression `/([^ ]+) : (.+)/` will match with a text that has the format 
# `"text_without_spaces : Any text"`. Every time the parser comes along a line of code which
# matches this expression, it will execute the block you provide. There is an additional parameter
# you can use in this block:
# - The `captures`, the result of matching the
# [regular expression](http://www.ruby-doc.org/core-1.9.3/Regexp.html) to the source.

# *Step by step:*

# We assign the second capture, which, with the example source given, will be `"First example"` in
# the very first case, to a local variable called `node`. 

# Again, at this point, we know that our parent is an `OpenStruct`. We define an attribute on it, 
# with the name taken from our captures object. This is what happens for each of the three cases:

# ```ruby
# #parent.send("#{captures[1]}=", node) translates to
# parent.example = "First example"
# parent.one = "Second example"
# parent.example = "Third example"
# ```

# Actually, the last line of the second block is not required, since there will not be any child
# to this node, so there is no block that would need the parent object as a parameter. You can
# return it anyways, just for the sake of thoroughness.

