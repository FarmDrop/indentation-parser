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
```

Then you read your special syntax from a file and parse it:

```ruby
source = IO.read("path/to/file")
output = parser.read(source, OpenStruct.new).value

puts output.this.is.an.example
puts output.this.is.the.second.one
puts output.this.serves.as.another.example
```

## Hooks

The following hooks are available:

```ruby
p.on /regex/ do |parent, source, captures|
  #...
end
```

```ruby
p.default do |parent, source|
  #...
end
```

```ruby
p.on_leaf /regex/ do |parent, source, captures|
  #...
end
```

```ruby
p.on_leaf do |parent, source|
  #...
end
```

```ruby
p.as_a_child_of Type do |parent, source|
  #...
end
```
