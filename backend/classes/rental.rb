# rental a car by a driver
class Rental
  attr_accessor :id, :car, :start_date, :end_date, :distance, :price
  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def calcul_rental_days
    rental_days = Date.parse(@end_date) - Date.parse(@start_date)
    if rental_days <= 0
      raise ArgumentError, 'End date should be greater than start date'
    end
    rental_days.to_int
  end

  def calcul_time_component
    calcul_rental_days * @car.price_per_day
  end

  def calcul_distance_component
    distance * @car.price_per_km
  end

  def calcul_price
    @price = (calcul_time_component + calcul_distance_component)
  end

  def self.create_rental_instances_with_calculate_price(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = []
    input_json['rentals'].each do |rental|
      rental = Rental.new(rental['id'],
                          cars.detect { |car| car.id == rental['car_id'] },
                          rental['start_date'],
                          rental['end_date'],
                          rental['distance'])
      rental.calcul_price
      rentals << rental
    end
    rentals
  end
end
