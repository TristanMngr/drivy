# rental a car by a driver
class Rental
  DESCREASING_PRICE_LONGER_RENTAL = {
    one_day: 10,
    four_days: 30,
    ten_days: 50
  }.freeze

  attr_accessor :id, :car, :start_date, :end_date, :distance
  attr_reader :rental_price, :rental_days

  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def calcul_rental_days
    rental_days = Date.parse(@end_date) - Date.parse(@start_date)
    if rental_days < 0
      raise DateError, 'End date should be greater than start date'
    end
    @rental_days = rental_days.to_int
  end

  def calcul_time_component(longer_rental_option = true)
    raise UndefinedError, "Car doesn't exist" if @car.nil?
    @rental_days = calcul_rental_days
    price_per_day = longer_rental_option ? price_per_day_for_longer_rental : @car.price_per_day 
    @rental_days * price_per_day
  end

  def price_per_day_for_longer_rental
    @rental_days = calcul_rental_days if @rental_days.nil?
    if rental_days >= 10
      return @car.price_per_day - (@car.price_per_day * DESCREASING_PRICE_LONGER_RENTAL[:ten_days] / 100) 
    elsif rental_days >= 4
      return @car.price_per_day - (@car.price_per_day * DESCREASING_PRICE_LONGER_RENTAL[:four_days] / 100)
    elsif rental_days >= 1
      return @car.price_per_day - (@car.price_per_day * DESCREASING_PRICE_LONGER_RENTAL[:one_day] / 100)
    else
      return @car.price_per_day
    end
  end

  def calcul_distance_component
    distance * @car.price_per_km
  end

  def calcul_price(longer_rental_option = true)
    time_component = longer_rental_option ? calcul_time_component : calcul_time_component(false)
    distance_component = calcul_distance_component
    @rental_price = (time_component + distance_component)
  end

  def self.apply_price_on_instances(rentals, longer_rental_option = true)
    rentals.each do |rental|
      longer_rental_option ? rental.calcul_price : rental.calcul_price(false)
    end
  end

  def self.create_rental_instances(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = []
    input_json['rentals'].each do |rental|
      rental = Rental.new(rental['id'],
                          cars.detect { |car| car.id == rental['car_id'] },
                          rental['start_date'],
                          rental['end_date'],
                          rental['distance'])
      rentals << rental
    end
    rentals
  end
end
