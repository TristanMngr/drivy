require_relative '../classes/rental.rb'
require_relative '../classes/car.rb'
require_relative '../classes/custom_error.rb'

describe Rental do
  describe 'calcul_rental_days' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul rental days' do
      expect(rental_one.calcul_rental_days).to equal(6)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_rental_days }
        .to raise_error(DateError, 'End date should be greater than start date')
    end

    it 'should raise an error when rental day equal 0' do
      expect { rental_two.calcul_rental_days }
        .to raise_error(DateError, 'End date should be greater than start date')
    end
  end

  describe 'calcul_time_component' do
    let(:car_one) { Car.new(1, 15, 2) }
    let(:car_two) { Car.new(2, 12, 1) }
    let(:rental_one) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:rental_two) { Rental.new(2, car_two, '2018-12-05', '2018-12-04', 100) }

    it 'should calcul time_component' do
      expect(rental_one.calcul_time_component).to equal(90)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_time_component }
        .to raise_error(DateError, 'End date should be greater than start date')
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
      expect(rental_one.calcul_price).to equal(479)
    end

    it 'should calcul the rental price without longer rental option' do
      expect(rental_one.calcul_price(false)).to equal(490)
    end

    it 'should raise an error when rental days inf 0' do
      expect { rental_two.calcul_price }
        .to raise_error(DateError, 'End date should be greater than start date')
    end
  end

  describe 'self.create_rental_instances' do
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
      cars = [car_one, car_two]
      instance = Rental.create_rental_instances(json, cars).sort_by(&:id)
      expect(instance[0].id).to eq(1)
      expect(instance[0].car.id).to eq(1)
      expect(instance[0].start_date).to eq('2017-12-8')
      expect(instance[0].end_date).to eq('2017-12-10')
      expect(instance[0].distance).to eq(100)
      expect(instance[0].rental_price).to eq(nil)
      expect(instance[1].rental_price).to eq(nil)
      expect(instance[2].rental_price).to eq(nil)
    end
  end

  describe 'self.apply_price_and_comission_on_instances' do
    let(:rental_instances) do
      [Rental.new(1, Car.new(1, 2000, 10), '2017-12-8', '2017-12-10', 100),
       Rental.new(2, Car.new(2, 3000, 15), '2017-12-8', '2017-12-10', 200)]
    end

    it 'should compute price on each instances of array' do
      expect(Rental.apply_price_and_comission_on_instances(rental_instances)
      .map(&:rental_price)).to eq([6600, 11400])
    end

    it 'should compute price on each instances of array without longer rental option' do
      expect(Rental.apply_price_and_comission_on_instances(rental_instances, false)
      .map(&:rental_price)).to eq([7000, 12000])
    end
  end

  describe 'price_per_day_for_longer_rental' do
    let(:car_one) { Car.new(1, 100, 2) }
    let(:rental_one_day) { Rental.new(1, car_one, '2018-12-10', '2018-12-11', 200) }
    let(:rental_five_day) { Rental.new(2, car_one, '2018-12-5', '2018-12-10', 200) }
    let(:rental_ten_day) { Rental.new(2, car_one, '2018-12-1', '2018-12-11', 200) }

    it 'should return the decreasing price per day when long rental' do
      rental_one_day.calcul_rental_days
      rental_five_day.calcul_rental_days
      rental_ten_day.calcul_rental_days
      expect(rental_one_day.compute_longer_rental).to eq(10)
      expect(rental_five_day.compute_longer_rental).to eq(90)
      expect(rental_ten_day.compute_longer_rental).to eq(260)
    end
  end

  describe 'calcul_commission' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should return the commission' do
      rental.calcul_price
      expect(rental.calcul_commission).to eq(1980)
      expect(rental.comission).to eq(1980)
    end
  end

  describe 'calcul_insurance_fee' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should return the insurance_fee' do
      rental.calcul_price
      rental.calcul_commission
      expect(rental.calcul_insurance_fee).to eq(990)
      expect(rental.insurance_fee).to eq(990)
    end
  end

  describe 'calcul_assistance_fee' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should return the assistance_fee' do
      expect(rental.calcul_assistance_fee).to eq(300)
      expect(rental.assistance_fee).to eq(300)
    end
  end

  describe 'calcul_drivy_fee' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should return the drivy_fee' do
      rental.calcul_price
      rental.calcul_commission
      expect(rental.calcul_drivy_fee).to eq(690)
      expect(rental.drivy_fee).to eq(690)
    end
  end

  describe 'compute_comissions' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should update rental attribute' do
      rental.calcul_price
      expect(rental.compute_comissions)
      expect(rental.insurance_fee).to eq(990)
      expect(rental.assistance_fee).to eq(300)
      expect(rental.drivy_fee).to eq(690)
      expect(rental.owner_share).to eq(4620)
    end
  end

  describe 'build_actions_payment' do
    let(:car_one) { Car.new(1, 2000, 10) }
    let(:rental) { Rental.new(1, car_one, '2018-12-8', '2018-12-10', 100) }

    it 'should update when insurance_fee assistance_fee driby_fee or owner_share is nil' do
      rental.calcul_price
      expect(rental.build_actions_payment)
      expect(rental.insurance_fee).to eq(990)
      expect(rental.assistance_fee).to eq(300)
      expect(rental.drivy_fee).to eq(690)
      expect(rental.owner_share).to eq(4620)
    end

    it 'should build actions hash' do
      rental.calcul_price
      expect(rental.build_actions_payment).to eq([{ amount: 6600, type: 'debit', who: 'driver' },
                                                  { amount: 4620, type: 'credit', who: 'owner' },
                                                  { amount: 990, type: 'credit', who: 'insurance' },
                                                  { amount: 300, type: 'credit', who: 'assistance' },
                                                  { amount: 690, type: 'credit', who: 'drivy' }])
    end
  end
end
