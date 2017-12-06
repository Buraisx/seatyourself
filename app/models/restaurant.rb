class Restaurant < ApplicationRecord
	has_many :reservations
	belongs_to :user

	validates :capacity, :name, :close_time, :open_time, :user_id, :address, :cuisine, presence: :true
	validates :capacity, numericality: {only_integer: true}

  def self.search(search)
  if search
    find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
  else
    find(:all)
  end
end



end
