# additional feature for driver gps, baby_seat, additional_insurance
class Option
  OPTION_TYPE_PRICES = {
    gps: 500,
    baby_seat: 200,
    additional_insurance: 1000
  }.freeze

  attr_accessor :id, :rental, :type
  attr_reader :option_price

  def initialize(id, rental, type)
    @id = id
    @rental = rental
    @type = type
  end

  def calcul_price_option
    raise MissingTypeError, "#{@type} is not available" unless OPTION_TYPE_PRICES.key?(@type.to_sym)
    @rental_days ||= @rental.calcul_rental_days
    @option_price = OPTION_TYPE_PRICES[@type.to_sym] * @rental.rental_days
  end

  def sync_option_with_rental
    @option_price = calcul_price_option
    @rental.options[@type.to_sym] = 0 if @rental.options[@type.to_sym].nil?
    @rental.options[@type.to_sym] = @option_price
  end

  # class method to instance all options from json file
  def self.create_option_instances(input_json, rentals)
    input_json['options'].map do |option|
      option = Option.new(option['id'],
                 rentals.detect { |rental| rental.id == option['rental_id'] },
                 option['type'])
      option.sync_option_with_rental
    end
  end
end
