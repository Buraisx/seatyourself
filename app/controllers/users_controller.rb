class UsersController < ApplicationController
	before_action :ensure_logged_in, except: [:new, :create]

	def new
		@user = User.new
	end

	def show
		@user = current_user
    @restaurants = Restaurant.all
    @reservations = Reservation.all

	end

	def edit
		@user = current_user
	end

	def create
		@user = User.new

		@user.name = params[:user][:name]
		@user.email = params[:user][:email]
		@user.password = params[:user][:password]
		@user.password_confirmation = params[:user][:password_confirmation]

		if @user.save
			user = User.find_by(email: params[:user][:email])
			session[:user_id] = user.id
			redirect_to root_url
		else
			render :new
		end
	end

	def update
		@user = current_user

		@user.name = params[:user][:name]
		@user.email = params[:user][:email]

		if @user.save
			redirect_to users_url
		else
			render :edit
		end
	end

	def destroy
		@user = current_user
		@user.destroy
		redirect_to new_users_url
	end
end
