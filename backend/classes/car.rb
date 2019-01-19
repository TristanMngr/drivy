require 'date'

class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end

  # class method to instance all cars from json file
  def self.create_car_instances(input_json)
    input_json['cars'].map do |car|
      Car.new(car['id'],
              car['price_per_day'],
              car['price_per_km'])
    end
  end
end
