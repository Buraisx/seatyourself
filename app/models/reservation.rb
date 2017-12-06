class Reservation < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant

	validates :user_id, :restaurant_id, :date_time, :party_size, presence: :true
	validates :party_size, numericality: {only_integer: true}
  validate :availability

  def availability
		# puts "!!!! #{self.inspect} !!!!"
    restaurant = Restaurant.find_by(id: restaurant_id)
    if restaurant

      capacity = restaurant.capacity
      reservations = Reservation.where( restaurant_id: restaurant_id)
      if date_time.hour <= restaurant.close_time.hour && date_time.hour >= restaurant.open_time.hour
        reservations.each do |reservation|
          dt = reservation.date_time
          if dt.day == date_time.day && dt.month == date_time.month && dt.year == date_time.year
            if dt.hour >= date_time.hour - 1.hour && dt.hour <= date_time.hour + 1.hour
              capacity -= reservation.party_size

            end
          end
          if capacity >= party_size
            return true
          else
            errors.add(:party_size, "Request exceeds Restaurant capacity")
          end
        end
        else
          errors.add(:date_time, "Restaurant closed for that time")
        end
      end
    end
  end



