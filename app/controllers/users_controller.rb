class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = policy_scope(User)
    if @users == current_user
      flash[:notice] = 'U heeft geen toegang tot deze index!'
      redirect_to users_path
    end
  end

  def show
    authorize @user
    # @order = @user.orders.last # Moet zijn opgesplitst in paid_-, send_- en stored_orders.
    @deliveries = @user.deliveries
  end

  def new
    authorize :user
    @user = User.new
  end

  def create
    @user = User.new # If not Pundit fails on a nil object.
    authorize @user
    @user.update(user_params)

    if @user.save
      flash[:notice] = "Gebruiker is toegevoegd."
      redirect_to users_path
    else
      flash.now[:alert] = "Gebruiker is niet toegevoegd."
      render "new"
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    if @user.update(user_params)
      if current_user.admin?
        flash[:notice] = 'Gebruiker is bijgewerkt.'
        redirect_to users_path
      else
        flash[:notice] = 'Uw gegevens zijn bijgewerkt.'
        redirect_to shop_path
      end
    else
      flash.now[:alert] = 'Gebruiker is niet bijgewerkt.'
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
