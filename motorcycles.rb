require 'CSV'

module Parser
  def self.parse_file(file)
    @bikes = []
    CSV.foreach(file) do |row|
      @bikes << Motorcycle.new({color: row[0], year: row[1], make: row[2]})
    end
    @bikes
  end
end

class Motorcycle
  attr_reader :color, :year, :make
  def initialize(args={})
    @color = args.fetch(:color)
    @year = args.fetch(:year).to_i
    @make = args.fetch(:make)
  end
end

class Dealership
  attr_reader :current_inventory
  def initialize(args={})
    @name = args.fetch(:name, "Tod's Rods")
    @current_inventory = []
  end

  def log_inventory(file)
    @current_inventory = Parser::parse_file(file)
  end

  def under_5_bikes
  @current_inventory.count do |bike|
    bike.year > 2010
    end
  end

  def japanese
    @current_inventory.count do |bike|
      bike.make == 'Honda' || bike.make == 'Suzuki'
    end
  end


  def query(color, year, make)
    matches = []
    @current_inventory.map do |bike|
      if bike.color == color && bike.year == year && bike.make == make
        matches << bike
      else
        bike
      end
    end
    matches.count
  end
end

tod = Dealership.new
tod.log_inventory('bikes.csv')
p tod.under_5_bikes
p tod.japanese
p tod.query("white", 2009, "BMW")
