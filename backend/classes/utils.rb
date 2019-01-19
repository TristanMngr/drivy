require 'json'

# all usefull method
module Utils
  def self.read_from_json(path)
    file = File.read(path)
    JSON.parse(file)
  end

  def self.build_hash_output_level_one(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = Rental.create_rental_instances(input_json, cars)
    Rental.apply_price_and_comission_on_instances(rentals, false)

    hash_output = { rentals: [] }

    rentals.each do |rental|
      hash_output[:rentals] << { id: rental.id, price: rental.rental_price }
    end
    hash_output
  end

  def self.build_hash_output_level_two(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = Rental.create_rental_instances(input_json, cars)
    Rental.apply_price_and_comission_on_instances(rentals)

    hash_output = { rentals: [] }

    rentals.each do |rental|
      hash_output[:rentals] << { id: rental.id, price: rental.rental_price }
    end
    hash_output
  end

  def self.build_hash_output_level_three(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = Rental.create_rental_instances(input_json, cars)
    Rental.apply_price_and_comission_on_instances(rentals)

    hash_output = { rentals: [] }

    rentals.each do |rental|
      hash_output[:rentals] << { id: rental.id,
                                price: rental.rental_price,
                                commission: {
                                  insurance_fee: rental.insurance_fee,
                                  assistance_fee: rental.assistance_fee,
                                  drivy_fee: rental.drivy_fee
                                } }
    end
    hash_output
  end

  def self.build_hash_output_level_four(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = Rental.create_rental_instances(input_json, cars)
    Rental.apply_price_and_comission_on_instances(rentals)

    hash_output = { rentals: [] }

    rentals.each do |rental|
      rental.build_actions_payment
      hash_output[:rentals] << { id: rental.id,
                                actions: rental.actions }
    end
    hash_output
  end

  def self.build_hash_output_level_five(input_json)
    cars = Car.create_car_instances(input_json)
    rentals = Rental.create_rental_instances(input_json, cars)
    options = Option.create_option_instances(input_json, rentals)
    Rental.apply_price_and_comission_on_instances(rentals)

    hash_output = { rentals: [] }

    rentals.each do |rental|
      rental.build_actions_payment
      hash_output[:rentals] << { id: rental.id,
                                options: rental.options.map { |key, _value| key },
                                actions: rental.actions }
    end
    hash_output
  end
end
