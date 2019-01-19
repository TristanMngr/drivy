# When a user rent a car a rent instance is created
class Rental
  DESCREASING_PRICE_LONGER_RENTAL = {
    one_day: 10,
    four_days: 30,
    ten_days: 50
  }.freeze

  PRICE_ONE_DAY = 10
  PRICE_FOUR_DAYS = 30
  PRICE_TEN_DAYS = 50

  COMMISSION = 30

  attr_accessor :id, :car, :start_date, :end_date, :distance,
                :owner_share, :drivy_fee,
                :options
  attr_reader :rental_price, :rental_days, :insurance_fee,
              :assistance_fee, :comission, :actions

  # I choose to store the object car but was it better to store the car_id ?
  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @options = {}
  end

  def calcul_rental_days
    rental_days = Date.parse(@end_date) - Date.parse(@start_date)
    if rental_days < 0
      raise DateError, 'End date should be greater than start date'
    end
    @rental_days = rental_days.zero? ? 1 : rental_days.to_int + 1
  end

  def calcul_time_component
    raise UndefinedError, "Car doesn't exist" if @car.nil?
    @rental_days = calcul_rental_days
    @rental_days * @car.price_per_day
  end

  def compute_longer_rental
    @rental_days ||= calcul_rental_days
    if @rental_days > 1 && @rental_days <= 4
      return @car.price_per_day * PRICE_ONE_DAY / 100 * (@rental_days - 1)
    elsif @rental_days > 4 && @rental_days <= 10
      return @car.price_per_day * PRICE_ONE_DAY / 100 * 3 +
             @car.price_per_day * PRICE_FOUR_DAYS / 100 * (@rental_days - 4)
    elsif @rental_days > 10
      return @car.price_per_day * PRICE_ONE_DAY / 100 * 3 +
             @car.price_per_day * PRICE_FOUR_DAYS / 100 * 6 +
             @car.price_per_day * PRICE_TEN_DAYS / 100 * (@rental_days - 10)
    end
    0
  end

  def calcul_distance_component
    raise UndefinedError, "Car doesn't exist" if @car.nil?
    distance * @car.price_per_km
  end

  def calcul_price(longer_rental_option = true)
    time_component = calcul_time_component
    distance_component = calcul_distance_component
    longer_rental_reduction = longer_rental_option == true ? compute_longer_rental : 0
    @rental_price = time_component + distance_component - longer_rental_reduction
  end

  def calcul_commission
    raise UndefinedError, 'Rental price should be calculated' if rental_price.nil?
    @comission = @rental_price * COMMISSION / 100
  end

  def calcul_insurance_fee
    raise UndefinedError, 'Rental price should be calculated' if rental_price.nil?
    raise UndefinedError, 'Comission should be calculated first' if @comission.nil?
    @insurance_fee = @comission / 2
  end

  def calcul_assistance_fee
    @rental_days ||= calcul_rental_days
    @assistance_fee = 100 * @rental_days
  end

  def calcul_drivy_fee
    raise UndefinedError, 'Comission should be calculated first' if @comission.nil?
    @insurance_fee ||= calcul_insurance_fee
    @assistance_fee ||= calcul_assistance_fee
    @drivy_fee = @comission - (@insurance_fee + assistance_fee)
    @drivy_fee
  end

  def calcul_owner_share
    raise UndefinedError, 'Comission should be calculated first' if @comission.nil?
    @rental_price ||= calcul_price
    @owner_share = @rental_price - @comission
  end

  def compute_comissions
    calcul_commission
    calcul_insurance_fee
    calcul_assistance_fee
    calcul_drivy_fee
    calcul_owner_share
  end

  def compute_final_price
    compute_comissions
    additional_insurance = @options[:additional_insurance].nil? ? 0 : @options[:additional_insurance]
    baby_seat = @options[:baby_seat].nil? ? 0 : @options[:baby_seat]
    gps = @options[:gps].nil? ? 0 : @options[:gps]

    @drivy_fee += additional_insurance
    @owner_share += (baby_seat + gps)
    @rental_price += (additional_insurance + baby_seat + gps)
  end

  def build_actions_payment
    if @insurance_fee.nil? || @assistance_fee.nil? || @drivy_fee.nil? || @owner_share.nil?
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
      rental.compute_final_price
    end
  end

  # class method to instance all rental from json file
  def self.create_rental_instances(input_json, cars)
    input_json['rentals'].map do |rental|
      rental = Rental.new(rental['id'],
                 cars.detect { |car| car.id == rental['car_id'] },
                 rental['start_date'],
                 rental['end_date'],
                 rental['distance'])
    end
  end
end
