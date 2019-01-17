require './utils'
require './classes/rental'
require './classes/car'

def build_hash_output(input_json)
  rentals = Rental.create_rental_instances(input_json)
  Rental.apply_price_and_comission_on_instances(rentals, false)

  hash_output = { rental: [] }

  rentals.each do |rental|
    hash_output[:rental] << { id: rental.id, price: rental.rental_price }
  end
  hash_output
end

input_json = Utils.read_from_json('./level1/data/input.json')

File.open('./level1/data/output.json', 'w') do |f|
  f.write(build_hash_output(input_json).to_json)
end
