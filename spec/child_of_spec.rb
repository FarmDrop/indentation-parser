require 'ostruct'

require 'indentation-parser'

class Universe < OpenStruct 
end
class Planet < OpenStruct 
end
class Continent < OpenStruct 
end
class Country < OpenStruct 
end

describe "blablabla!!" do
  
  it 'does a lot' do
    parser = IndentationParser.new do |p|      
      p.as_a_child_of Universe do |parent, indentation, source|
        planet = Planet.new
        planet.name = source
        parent.send "#{source}=", planet
        planet
      end
      
      p.as_a_child_of Planet do |parent, indentation, source|
        continent = Continent.new
        continent.name = source
        parent.send "#{source}=", continent
        continent
      end
      
      p.as_a_child_of Continent do |parent, indentation, source|
        country = Country.new
        country.name = source
        parent.send "#{source}=", country
        country
      end

      p.as_a_child_of Country do |parent, indentation, source|
        captures = /([^ ]+) = ([0-9]+)/.match source
        parent.send "#{captures[1]}=", captures[2]
      end

    end
   
    source = IO.read("spec/other.universe")
    universe = parser.read(source, Universe.new).value
    
    puts universe.earth.name
    puts universe.earth.europe.switzerland.name
    puts universe.earth.europe.switzerland.population

  end
end