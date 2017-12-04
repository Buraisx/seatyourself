class SessionsController < ApplicationController

def new
end

def create
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to user_reservations_url, notice: "Logged in!"
  else
    flash.alert = "Incorrect login. Please try again."
    render :new
  end
end

def destroy
  session[:user_id] = nil
  redirect_to restaurants_url, notice: "Logged out"
end 

end