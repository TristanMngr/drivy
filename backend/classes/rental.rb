# rental a car by a driver
class Rental
  DESCREASING_PRICE_LONGER_RENTAL = {
    one_day: 10,
    four_days: 30,
    ten_days: 50
  }.freeze

  COMMISSION = 30

  attr_accessor :id, :car, :start_date, :end_date, :distance
  attr_reader :rental_price, :rental_days, :insurance_fee,
              :assistance_fee, :drivy_fee, :owner_share, :comission, :actions

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

  def calcul_commission
    @rental_price ||= calcul_price
    @comission = @rental_price * COMMISSION / 100
  end

  def calcul_insurance_fee
    @rental_price ||= calcul_price
    @comission ||= calcul_commission
    @insurance_fee = @comission / 2
  end

  def calcul_assistance_fee
    @rental_days ||= calcul_rental_days
    @assistance_fee = 100 * @rental_days
  end

  def calcul_drivy_fee
    @comission ||= calcul_commission
    @insurance_fee ||= calcul_insurance_fee
    @assistance_fee ||= calcul_assistance_fee
    @drivy_fee = @comission - (@insurance_fee + assistance_fee)
  end

  def calcul_owner_share
    @rental_price ||= calcul_price
    @comission ||= calcul_commission
    @owner_share = @rental_price - @comission
  end

  def compute_comissions
    calcul_insurance_fee
    calcul_assistance_fee
    calcul_drivy_fee
    calcul_owner_share
  end

  def build_actions_payment
    if insurance_fee.nil? || assistance_fee.nil? || drivy_fee.nil? || owner_share.nil?
      compute_comissions
    end

    driver = { who: 'driver', type: 'debit', amount: @rental_price }
    owner = { who: 'owner', type: 'credit', amount: @owner_share }
    insurance = { who: 'insurance', type: 'credit', amount: @insurance_fee }
    assistance = { who: 'assistance', type: 'credit', amount: @assistance_fee }
    drivy = { who: 'drivy', type: 'credit', amount: @drivy_fee }

    @actions = [driver, owner, insurance, assistance, drivy]
  end

  def self.apply_price_and_comission_on_instances(rentals,
                                                  longer_rental_option = true)
    rentals.each do |rental|
      longer_rental_option ? rental.calcul_price : rental.calcul_price(false)
      rental.compute_comissions
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
