class Admin::UsersController < ApplicationController

  before_filter :admin_only

  def index
    @users = User.all.page(params[:page]).per(3)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to movies_path, notice: "Welcome aboard, #{@user.firstname}!"
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      redirect_to admin_users_path, notice: "#{@user.full_name} was updated successfully!"
    else
      render :edit
    end
  end
  
  def show
    @user = User.find(params[:id])
  end

  def destroy
    @user = User.find(params[:id])
    if @user
      respond_to do |format|
        UserMailer.delete_account_email(@user)
        format.html { redirect_to(admin_users_path, notice: 'User was successfully deleted.') }
        @user.destroy
      end
    else
      redirect_to admin_users_path
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email, :firstname, :lastname, :password, :password_confirmation, :admin)
  end
end
