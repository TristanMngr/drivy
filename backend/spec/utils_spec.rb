require_relative '../classes/utils.rb'
require_relative '../classes/rental.rb'
require_relative '../classes/car.rb'
require_relative '../classes/option.rb'
require_relative '../classes/custom_error.rb'

describe Utils do
  describe 'self.build_hash_output_level_one' do
    let(:hash_input) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 },
          { 'id' => 2, 'price_per_day' => 3000, 'price_per_km' => 15 },
          { 'id' => 3, 'price_per_day' => 1700, 'price_per_km' => 8 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2017-12-8', 'end_date' => '2017-12-10', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2017-12-14', 'end_date' => '2017-12-18', 'distance' => 550 },
          { 'id' => 3, 'car_id' => 2, 'start_date' => '2017-12-8', 'end_date' => '2017-12-10', 'distance' => 150 }
        ]
      }
    end
    it 'should return a correct hash' do
      expect(Utils.build_hash_output_level_one(hash_input)).to eq(
        rentals: [
          {
            id: 1,
            price: 7000
          },
          {
            id: 2,
            price: 15_500
          },
          {
            id: 3,
            price: 11_250
          }
        ]
      )
    end
  end

  describe 'self.build_hash_output_level_two' do
    let(:hash_input) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2015-12-8', 'end_date' => '2015-12-8', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2015-03-31', 'end_date' => '2015-04-01', 'distance' => 300 },
          { 'id' => 3, 'car_id' => 1, 'start_date' => '2015-07-3', 'end_date' => '2015-07-14', 'distance' => 1000 }
        ]
      }
    end

    it 'should return a correct hash' do
      expect(Utils.build_hash_output_level_two(hash_input)).to eq(
        rentals: [
          {
            id: 1,
            price: 3000
          },
          {
            id: 2,
            price: 6800
          },
          {
            id: 3,
            price: 27_800
          }
        ]
      )
    end
  end

  describe 'self.build_hash_output_level_three' do
    let(:hash_input) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2015-12-8', 'end_date' => '2015-12-8', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2015-03-31', 'end_date' => '2015-04-01', 'distance' => 300 },
          { 'id' => 3, 'car_id' => 1, 'start_date' => '2015-07-3', 'end_date' => '2015-07-14', 'distance' => 1000 }
        ]
      }
    end

    it 'should return a correct hash' do
      expect(Utils.build_hash_output_level_three(hash_input)).to eq(
        rentals: [
          {
            id: 1,
            price: 3000,
            commission: {
              insurance_fee: 450,
              assistance_fee: 100,
              drivy_fee: 350
            }
          },
          {
            id: 2,
            price: 6800,
            commission: {
              insurance_fee: 1020,
              assistance_fee: 200,
              drivy_fee: 820
            }
          },
          {
            id: 3,
            price: 27_800,
            commission: {
              insurance_fee: 4170,
              assistance_fee: 1200,
              drivy_fee: 2970
            }
          }
        ]
      )
    end
  end

  describe 'self.build_hash_output_level_four' do
    let(:hash_input) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2015-12-8', 'end_date' => '2015-12-8', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2015-03-31', 'end_date' => '2015-04-01', 'distance' => 300 },
          { 'id' => 3, 'car_id' => 1, 'start_date' => '2015-07-3', 'end_date' => '2015-07-14', 'distance' => 1000 }
        ]
      }
    end

    it 'should return a correct hash' do
      expect(Utils.build_hash_output_level_four(hash_input)).to eq(
        rentals: [
          {
            id: 1,
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 3000
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 2100
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 450
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 100
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 350
              }
            ]
          },
          {
            id: 2,
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 6800
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 4760
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 1020
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 200
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 820
              }
            ]
          },
          {
            id: 3,
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 27_800
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 19_460
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 4170
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 1200
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 2970
              }
            ]
          }
        ]
      )
    end
  end

  describe 'self.build_hash_output_level_five' do
    let(:hash_input) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2015-12-8', 'end_date' => '2015-12-8', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2015-03-31', 'end_date' => '2015-04-01', 'distance' => 300 },
          { 'id' => 3, 'car_id' => 1, 'start_date' => '2015-07-3', 'end_date' => '2015-07-14', 'distance' => 1000 }
        ],
        'options' => [
          { 'id' => 1, 'rental_id' => 1, 'type' => 'gps' },
          { 'id' => 2, 'rental_id' => 1, 'type' => 'baby_seat' },
          { 'id' => 3, 'rental_id' => 2, 'type' => 'additional_insurance' }
        ]
      }
    end

    it 'should return a correct hash' do
      expect(Utils.build_hash_output_level_five(hash_input)).to eq(
        rentals: [
          {
            id: 1,
            options: [
              :gps,
              :baby_seat
            ],
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 3700
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 2800
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 450
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 100
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 350
              }
            ]
          },
          {
            id: 2,
            options: [
              :additional_insurance
            ],
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 8800
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 4760
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 1020
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 200
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 2820
              }
            ]
          },
          {
            id: 3,
            options: [],
            actions: [
              {
                who: 'driver',
                type: 'debit',
                amount: 27_800
              },
              {
                who: 'owner',
                type: 'credit',
                amount: 19_460
              },
              {
                who: 'insurance',
                type: 'credit',
                amount: 4170
              },
              {
                who: 'assistance',
                type: 'credit',
                amount: 1200
              },
              {
                who: 'drivy',
                type: 'credit',
                amount: 2970
              }
            ]
          }
        ]
      )
    end
  end
end
