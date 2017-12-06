class ReservationsController < ApplicationController
  before_action :ensure_logged_in
  before_action :load_reservation, only: [:show, :edit, :update, :destroy]
  # before_action :ensure_user_owns_reservation, except: [:new, :create]

  def load_reservation
        @reservation = Reservation.find(params[:id])
  end

  def ensure_user_owns_reservation
  	@reservations = Reservation.find_by(user_id: params[:user_id])
    unless current_user.id == @reservations.user_id
      flash[:alert] = "Please log in"
      redirect_to new_sessions_url
    end
  end

  def index
	  @reservations = Reservation.find_by(user_id: params[:user_id])
  end

  def show
  end

  def new
    @user = current_user
    @restaurants = Restaurant.all
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new
    @reservation.user_id = current_user.id
    @reservation.restaurant_id = params[:reservation][:restaurant_id]
    @reservation.date_time = Time.utc(params[:reservation]["date_time(1i)"].to_i,
                                        params[:reservation]["date_time(2i)"].to_i,
                                        params[:reservation]["date_time(3i)"].to_i,
                                        params[:reservation]["date_time(4i)"].to_i,
                                        params[:reservation]["date_time(5i)"].to_i)
    @reservation.party_size = params[:reservation][:party_size]
      if @reservation.save

      flash[:notice] = "Reservation was successfully booked!"
      redirect_to users_url
    else
      redirect_to new_users_reservation_url


        flash[:notice] = @reservation.errors.full_messages


    end
  end

  def edit
    @user = current_user
    @restaurant = @reservation.restaurant
    @restaurants = Restaurant.all
  end

  def update
    @reservation.user_id = current_user.id
    @reservation.restaurant_id = params[:reservation][:restaurant_id]
    @reservation.date_time = Time.utc(params[:reservation]["date_time(1i)"].to_i,
                                        params[:reservation]["date_time(2i)"].to_i,
                                        params[:reservation]["date_time(3i)"].to_i,
                                        params[:reservation]["date_time(4i)"].to_i,
                                        params[:reservation]["date_time(5i)"].to_i)
    @reservation.party_size = params[:reservation][:party_size]
    if @reservation.save
      flash[:notice] = "Reservation was successfully updated!"
      redirect_to users_url
    else
      redirect_to edit_users_reservation_url(@reservation.id)
      flash[:notice] =  "#{@reservation.errors.values.flatten}"
    end
  end

  def destroy
    @reservation.destroy
    flash[:notice] = "You have canceled your reservation"
    redirect_to users_url
  end

end
