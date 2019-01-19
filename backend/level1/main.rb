require './classes/utils'
require './classes/rental'
require './classes/car'

FILE_INPUT_PATH = './level1/data/input.json'.freeze
FILE_OUTPUT_PATH = './level1/data/output.json'.freeze

input_json = Utils.read_from_json(FILE_INPUT_PATH)

File.open(FILE_OUTPUT_PATH, 'w') do |f|
  f.write(Utils.build_hash_output_level_one(input_json).to_json)
end
