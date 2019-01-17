require 'date'

# car propriety
class Car
  attr_accessor :id, :price_per_day, :price_per_km

  def initialize(id, price_per_day, price_per_km)
    @id = id
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end

  def self.create_car_instances(input_json)
    cars = []
    input_json['cars'].each do |car|
      car = Car.new(car['id'],
                    car['price_per_day'],
                    car['price_per_km'])
      cars << car
    end
    cars
  end
end
