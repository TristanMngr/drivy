require_relative '../classes/rental.rb'
require_relative '../classes/car.rb'
require_relative '../classes/option.rb'
require_relative '../classes/custom_error.rb'

describe Option do
  describe 'calcul_price_option' do
    let(:car_one) { Car.new(1, 1000, 20) }
    let(:rental) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:option) { Option.new(1, rental, 'gps') }

    it 'should return an error when type option is not define' do
      option.type = 'ordinateur'
      expect { option.calcul_price_option }
        .to raise_error('ordinateur is not available')
    end

    it 'should calculate and update option_price for gps' do
      rental.calcul_rental_days
      expect(option.calcul_price_option).to eq(3000)
    end

    it 'should calculate and update option_price for gps' do
      rental.calcul_rental_days
      option.type = 'baby_seat'
      expect(option.calcul_price_option).to eq(1200)
    end

    it 'should calculate and update option_price for gps' do
      rental.calcul_rental_days
      option.type = 'additional_insurance'
      expect(option.calcul_price_option).to eq(6000)
    end
  end

  describe 'sync_option_with_rental' do
    let(:car_one) { Car.new(1, 1000, 20) }
    let(:rental) { Rental.new(1, car_one, '2018-12-05', '2018-12-10', 200) }
    let(:option_gps) { Option.new(1, rental, 'gps') }
    let(:option_insurance) { Option.new(2, rental, 'additional_insurance') }
    let(:option_baby_seat) { Option.new(3, rental, 'baby_seat') }

    it 'should update rental price with option price' do
      rental.calcul_price
      expect(rental.compute_comissions)
      expect(rental.drivy_fee).to eq(765)
      expect(rental.owner_share).to eq(6370)
      expect(rental.rental_price).to eq(9100)
      # option gps
      expect(option_gps.sync_option_with_rental)
      expect(rental.drivy_fee).to eq(765)
      expect(rental.owner_share).to eq(6370)
      expect(rental.rental_price).to eq(9100)
      # option insurance and baby seat
      expect(option_insurance.sync_option_with_rental)
      expect(option_baby_seat.sync_option_with_rental)
      expect(rental.drivy_fee).to eq(765)
      expect(rental.owner_share).to eq(6370)
      expect(rental.rental_price).to eq(9100)
      expect(rental.options).to eq({:additional_insurance=>6000, :baby_seat=>1200, :gps=>3000})
    end
  end
end
