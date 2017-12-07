class Reservation < ApplicationRecord
	belongs_to :user
	belongs_to :restaurant

	validates :user_id, :restaurant_id, :date_time, :party_size, presence: :true
	validates :party_size, numericality: {only_integer: true}
  validate :date_cannot_be_in_past
  validate :availability

  def date_cannot_be_in_past
    errors.add(:date_time, "can't be in the past") if date_time < Time.now
  end


  def availability
		# puts "!!!! #{self.inspect} !!!!"
    restaurant = Restaurant.find_by(id: restaurant_id)
    if restaurant
      group_time = 0
      capacity = restaurant.capacity.to_i
      reservations = Reservation.where( restaurant_id: restaurant_id)
      if date_time.hour <= restaurant.close_time.hour && date_time.hour >= restaurant.open_time.hour
        reservations.each do |reservation|
          dt = reservation.date_time
          if dt.day == date_time.day && dt.month == date_time.month && dt.year == date_time.year
            reservation.party_size.times do
            group_time += 0.25
          end
            if dt.hour >= date_time.hour - group_time && dt.hour <= date_time.hour + group_time
              capacity -= reservation.party_size
            end
          end
        end

          if capacity >= party_size
            return true
          else
            errors.add(:party_size, "Request exceeds Restaurant capacity")
          end

        else
          errors.add(:date_time, "Restaurant closed for that time")
        end
      end

  end


end
