require_relative '../classes/car.rb'

describe Car do
  describe 'self.create_car_instances' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:car_two) { Car.new(2, 3000, 15) }
    let!(:json) do
      {
        'cars' => [
          { 'id' => 1, 'price_per_day' => 2000, 'price_per_km' => 10 },
          { 'id' => 2, 'price_per_day' => 3000, 'price_per_km' => 15 }
        ],
        'rentals' => [
          { 'id' => 1, 'car_id' => 1, 'start_date' => '2017-12-8',
            'end_date' => '2017-12-10', 'distance' => 100 },
          { 'id' => 2, 'car_id' => 1, 'start_date' => '2017-12-14',
            'end_date' => '2017-12-18', 'distance' => 550 },
          { 'id' => 3, 'car_id' => 2, 'start_date' => '2017-12-8',
            'end_date' => '2017-12-10', 'distance' => 150 }
        ]
      }
    end

    it 'should return correct object' do
      cars = Car.create_car_instances(json).sort_by(&:id)
      expect(cars.length).to eq(2)
      expect(cars[0].id).to eq(1)
      expect(cars[0].price_per_day).to eq(2000)
      expect(cars[0].price_per_km).to eq(10)
      expect(cars[1].id).to eq(2)
      expect(cars[1].price_per_day).to eq(3000)
      expect(cars[1].price_per_km).to eq(15)
    end
  end
end
