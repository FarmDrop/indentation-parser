
# Indentation-Parser 

[![Build Status](https://secure.travis-ci.org/ssmm/indentation-parser.png)](http://travis-ci.org/ssmm/indentation-parser) 
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/ssmm/indentation-parser)

Parses source code that defines context by indentation.

## How

Assume you have this structure:

	this
	  is
	    an
	      example : First example
	    the
	      second
	        one : Second example
	  serves
	    as
	      another
	        example : Third example

You want to create an output which you can use like this:

```ruby
puts output.this.is.an.example
# => "First example"

puts output.this.is.the.second.one
# => "Second example"

puts output.this.serves.as.another.example
# => "Third example"
```

You write a parser like so:

```ruby
parser = IndentationParser.new do |p|
  p.on /([^ ]+) : (.+)/ do |parent, indentation, source, captures|
    node = captures[2]
    parent.send("#{captures[1]}=", node)
    node
  end

  p.default do |parent, indentation, source|
    node = OpenStruct.new
    parent.send("#{source}=", node)
    node
  end  
end
```

Then you read your special syntax from a file and parse it:

```ruby
source = IO.read("path/to/file")
output = parser.read(source, OpenStruct.new).value

puts output.this.is.an.example
puts output.this.is.the.second.one
puts output.this.serves.as.another.example
```

# Details

Lets take a closer look at the example above first:



Explain the default here first!




```ruby
p.on /([^ ]+) : (.+)/ do |parent, indentation, source, captures|
  node = captures[2]
  parent.send("#{captures[1]}=", node)
  node
end
```

The regular expression `/([^ ]+) : (.+)/` will match with a text that has the format 
`"text_without_spaces : Any text"`. Every time the parser comes along a line of code which
matches this expression, it will execute the block you provide. 

The parameters you get from the parsers inside your block are:

The `parent` node. This is the object you have set for an already parsed line.

The `indentation` count, an integer. Currently, the parser only supports indentations with 
spaces (no tabs). One indentation = two spaces.

The `source`, basically the whole line the parser currently evaluates without indentation.

The `captures`, the result of matching the regular expression to the source.

So, lets walk through the code line by line:

```ruby
node = captures[2]
```

This assigns the second [capture](http://www.ruby-doc.org/core-1.9.3/Regexp.html), which, with
the example source given, will be `"First example"`in the very first case, to a local variable
called `node`. 

```ruby
parent.send("#{captures[1]}=", node)
```

Since we defined our parser to create `OpenStruct`s in every default case, this is what actually
happens:

```ruby
parent.example = node
```

`parent` is an `OpenStruct`, and we define an attribute called `example` on it.


