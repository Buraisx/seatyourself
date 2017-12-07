class RestaurantsController < ApplicationController
before_action :ensure_logged_in, except: [:index, :show]
before_action :load_restaurant, only: [:show, :edit, :update, :destroy]
before_action :ensure_user_owns_restaurant, only: [:edit, :update, :destroy]


  def load_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def ensure_user_owns_restaurant
    unless current_user == @restaurant.user
    flash[:alert] = "Please log in"
    redirect_to new_sessions_url
    end
  end

  def search_params
    params.require(:search).permit(:name, :cuisine)
  end


  def index
    @restaurants = if params[:search]
      Restaurant.where('name Like ?', "%#{params[:search]}%").or(Restaurant.where('cuisine Like ?', "%#{params[:search]}%")).or(Restaurant.where('address Like ?', "%#{params[:search]}%"))
    else
      Restaurant.all
    end

  end

  def show
    @user = current_user
    @restaurants = Restaurant.all
    @reservation = Reservation.new
    @reservations = @restaurant.reservations
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new
    @restaurant.name = params[:restaurant][:name]
    @restaurant.cuisine = params[:restaurant][:cuisine]
    @restaurant.address = params[:restaurant][:address]
    @restaurant.capacity = params[:restaurant][:capacity]
    @restaurant.close_time = Time.utc(params[:restaurant]["close_time(1i)"].to_i,
                                        params[:restaurant]["close_time(2i)"].to_i,
                                        params[:restaurant]["close_time(3i)"].to_i,
                                        params[:restaurant]["close_time(4i)"].to_i,
                                        params[:restaurant]["close_time(5i)"].to_i)
    @restaurant.open_time = Time.utc(params[:restaurant]["open_time(1i)"].to_i,
                                        params[:restaurant]["open_time(2i)"].to_i,
                                        params[:restaurant]["open_time(3i)"].to_i,
                                        params[:restaurant]["open_time(4i)"].to_i,
                                        params[:restaurant]["open_time(5i)"].to_i)
    @restaurant.user_id = current_user.id
    @restaurant.image_url = params[:restaurant][:image_url]

    if @restaurant.save
      redirect_to restaurants_url
    else
      render :new
    end

  end

  def edit
  end

  def update
    @restaurant.name = params[:restaurant][:name]
    @restaurant.address = params[:restaurant][:address]
    @restaurant.capacity = params[:restaurant][:capacity]
    @restaurant.close_time = Time.utc(params[:restaurant]["close_time(1i)"].to_i,
                                        params[:restaurant]["close_time(2i)"].to_i,
                                        params[:restaurant]["close_time(3i)"].to_i,
                                        params[:restaurant]["close_time(4i)"].to_i,
                                        params[:restaurant]["close_time(5i)"].to_i)
    @restaurant.open_time = Time.utc(params[:restaurant]["open_time(1i)"].to_i,
                                        params[:restaurant]["open_time(2i)"].to_i,
                                        params[:restaurant]["open_time(3i)"].to_i,
                                        params[:restaurant]["open_time(4i)"].to_i,
                                        params[:restaurant]["open_time(5i)"].to_i)
    @restaurant.user_id = params[:restaurant][:user_id]
    @restaurant.image_url = params[:restaurant][:image_url]
    @restaurant.user_id = current_user.id

    if @restaurant.save
      redirect_to restaurants_url
    else
      render :edit
    end

  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_url
  end

end
