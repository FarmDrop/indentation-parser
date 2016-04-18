# Indentation-Parser

[![Build Status](https://secure.travis-ci.org/samu/indentation-parser.png)](http://travis-ci.org/samu/indentation-parser)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/samu/indentation-parser)

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

## Non-indented blocks

If you need to not have some part of the code parsed for some reason e.g.
you want to have a block of text that will later be turned into Markdown,
you can define a parser that sets the value of the block's parent to a class
that respoonds to `stop_indentation?` by returning `true`.

For example:

```ruby
class DocNode < String
  def initialize
    @stop_indentation = false
    super
  end

  # Set this to true in a handler to ignore all indentation in the child
  # text. Good for markdown formatting etc.
  def stop_indentation!
    @stop_indentation = true
  end

  def stop_indentation?
    @stop_indentation
  end
end

parser = IndentationParser.new do |p|
  p.on /description/ do |parent, source, captures|
    parent.description = DocNode.new.tap(&:stop_indentation!)
  end
end
```