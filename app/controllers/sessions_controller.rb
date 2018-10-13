class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by username: params[:username]

      if user && user.banned
        redirect_to signin_path, notice: "Account is banned"
        return
      end

      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user), notice: "Welcome back!"
        return
      else
        redirect_to signin_path, notice: "Username and/or password mismatch"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to :root
    end
end
