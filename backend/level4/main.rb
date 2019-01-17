require './utils'
require './classes/rental'
require './classes/car'

def build_hash_output(input_json)
  rentals = Rental.create_rental_instances(input_json)
  Rental.apply_price_and_comission_on_instances(rentals)

  hash_output = { rental: [] }

  rentals.each do |rental|
    rental.build_actions_payment
    hash_output[:rental] << { id: rental.id,
                              actions: rental.actions }
  end
  hash_output
end

input_json = Utils.read_from_json('./level4/data/input.json')

File.open('./level4/data/output.json', 'w') do |f|
  f.write(build_hash_output(input_json).to_json)
end
