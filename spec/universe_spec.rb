require 'indentation-parser'

Universe = Struct.new(:planets)
Planet = Struct.new(:name, :continents)
Continent = Struct.new(:name, :countries)
Country = Struct.new(:name, :population, :currency, :specialities)

describe IndentationParser do
  it "parses a .universe file" do
    parser = IndentationParser.new do |p|
      
      p.on /planet = ([a-zA-Z]+)/ do |parent, indentation, source, captures|
        planet = Planet.new captures[1]
        planet.continents = []
        parent.planets << planet
        planet
      end
      
      p.on /continent = ([a-zA-Z]+)/ do |parent, indentation, source, captures|
        continent = Continent.new captures[1]
        continent.countries = []
        parent.continents << continent
        continent
      end
      
      p.on /country = ([a-zA-Z]+)/ do |parent, indentation, source, captures|
        country = Country.new captures[1]
        parent.countries << country
        country
      end
      
      p.on /population = ([0-9]+)/ do |parent, indentation, source, captures|
        parent.population = captures[1].to_i
      end
      
      p.on /currency = ([a-zA-Z]+)/ do |parent, indentation, source, captures|
        parent.currency = captures[1]
      end
      
      p.on /specialities:/ do |parent, indentation, source, captures|
        parent.specialities = []
      end      
      
      p.else do |parent, indentation, source|
        parent << source  
      end
      
    end
    
    source = IO.read("spec/the.universe")
    universe = Universe.new
    universe.planets = []
    result = parser.read(source, universe).value
    
    puts result.planets.first.continents.first.countries
  end
end
