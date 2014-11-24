class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/name
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    
    @user = User.new(user_params)
    @user.profile_image = params[:user][:profile_image]
    respond_to do |format|
      if @user.save
        log_in @user
        format.html { redirect_to root_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if params[:user][:password].blank?
        params[:user].delete(:password)
      end
      if @user.update(user_params)
        flash[:sucess] = 'Your account information has been updated sucessfully.' 
        format.html { redirect_to root_path}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def login
    if logged_in?
      redirect_to root_path
    end 
    if request.post?
      user = User.find_by(username: params[:user][:username])
      if user && user.authenticate(params[:user][:password])
        log_in user
        redirect_to root_path
      else
        flash[:danger] = 'Invalid Username/password combination.'
        redirect_to login_path
      end
    end
  end
  
  def logout
    log_out
    redirect_to root_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    if logged_in?
      @user = User.find(session[:user_id])
    else
      flash[:danger] = 'Please Sign-up first.'
      redirect_to registration_url
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :firstname, :lastname, :password, :confirm_password)
  end
end
