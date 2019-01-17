require_relative '../classes/rental.rb'
require_relative '../classes/car.rb'

describe Rental do
  describe 'calcul_rental_days' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul rental days' do
      expect(rental_one.calcul_rental_days).to equal(5)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_rental_days }
        .to raise_error(ArgumentError, 'End date should be greater than start date')
    end

    it 'should raise an error when rental day equal 0' do
      expect { rental_two.calcul_rental_days }
        .to raise_error(ArgumentError, 'End date should be greater than start date')
    end
  end

  describe 'calcul_time_component' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul time_component' do
      expect(rental_one.calcul_time_component).to equal(75)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_time_component }
        .to raise_error(ArgumentError, 'End date should be greater than start date')
    end
  end

  describe 'calcul_distance_component' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul distance_component' do
      expect(rental_one.calcul_distance_component).to equal(400)
    end

    it 'should raise an error when rental days inf 0' do
      expect(rental_two.calcul_distance_component).to equal(100)
    end
  end

  describe 'calcul_price' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul the rental price' do
      expect(rental_one.calcul_price).to equal(475)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_price }
        .to raise_error(ArgumentError, 'End date should be greater than start date')
    end
  end

  describe 'self.create_rental_instances_with_calculate_price' do
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

    it 'should return a array of rental instance with calculate price' do
      instance = Rental.create_rental_instances_with_calculate_price(json).sort_by(&:id)
      expect(instance[0].id).to eq(1)
      expect(instance[0].car.id).to eq(1)
      expect(instance[0].start_date).to eq('2017-12-8')
      expect(instance[0].end_date).to eq('2017-12-10')
      expect(instance[0].distance).to eq(100)
      expect(instance[0].price).to eq(5000)
      expect(instance[1].price).to eq(13_500)
      expect(instance[2].price).to eq(8250)
    end
  end
end
