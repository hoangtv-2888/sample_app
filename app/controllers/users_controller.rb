class UsersController < ApplicationController
  include Pagy::Backend
  before_action :logged_in_user, except: %i(new create)
  before_action :find_user_by_id, except: %i(new index create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @user = pagy User.all, items: Settings.paging_numbers
  end

  def new
    @user = User.new
  end

  def show
    @pagy, @microposts = pagy @user.feed, items: Settings.paging_numbers
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "check_your_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    @user = User.find_by id: params[:id]
    if @user.update(user_params)
      flash[:success] = t "updated"
      redirect_to @user
    else
      flash[:danger] = t "update_failed"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "success"
    redirect_to users_path
  end

  def following
    @title = t "following"
    @pagy, @user = pagy @user.following, items: Settings.paging_numbers
    render "show_follow"
  end

  def followers
    @title = t "followers"
    @pagy, @user = pagy @user.followers, items: Settings.paging_numbers
    render "show_follow"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def correct_user
    redirect_to root_path unless current_user? @user
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user_not_found"
    redirect_to help_path
  end
end
