require 'indentation-parser'

Universe = Struct.new(:planets)
Planet = Struct.new(:name, :continents)
Continent = Struct.new(:name, :countries)
Country = Struct.new(:name, :population, :currency, :specialities, :description)

describe IndentationParser do
  it "parses a .universe file" do
    parser = IndentationParser.new do |p|

      p.on /planet = ([a-zA-Z]+)/ do |parent, source, captures|
        planet = Planet.new captures[1]
        planet.continents = []
        parent.planets << planet
        planet
      end

      p.on /continent = ([a-zA-Z]+)/ do |parent, source, captures|
        continent = Continent.new captures[1]
        continent.countries = []
        parent.continents << continent
        continent
      end

      p.on /country = ([a-zA-Z]+)/ do |parent, source, captures|
        country = Country.new captures[1]
        parent.countries << country
        country
      end

      p.on /population = ([0-9]+)/ do |parent, source, captures|
        parent.population = captures[1].to_i
      end

      p.on /currency = ([a-zA-Z]+)/ do |parent, source, captures|
        parent.currency = captures[1]
      end

      p.on /specialities/ do |parent, source, captures|
        parent.specialities = []
      end

      p.on /description/ do |parent, source, captures|
        parent.description = ''
      end

      p.as_a_child_of Array do |parent, source|
        parent << source
      end

      p.on_leaf do |parent, source|
        parent << "\n" if parent.length != 0
        parent << source.strip
      end
    end

    source = IO.read("spec/material/the.universe")
    universe = Universe.new
    universe.planets = []
    result = parser.read(source, universe).value

    countries = result.planets.first.continents.first.countries

    switzerland = countries.shift
    switzerland.name.should eq "Switzerland"
    switzerland.population.should eq 8
    switzerland.specialities.should eq ["chocolate", "cheese"]

    england = countries.shift
    england.name.should eq "England"
    england.population.should eq 40
    england.specialities.should eq ["fish'n'chips", "drum'n'bass"]

    america = result.planets.first.continents[1].countries.first
    america.description.should eq "A line of text\n\nAnother line after a whitespace line"
  end
end
