class UsersController < ApplicationController

  before_filter :autenticate_user, :only => [:show, :edit, :update]
  after_filter  :add_origin_header

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = User.encrypt_password(@user.password)

    respond_to do |format|
      if @user.save
        # Auto login
        session[:user_id] = @user.id
        format.html { redirect_to jobs_path, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /logout
  def logout
    session.clear
    redirect_to login_path
  end

  # GET /login
  def login
    @user = User.new
  end

  # POST /login
  def create_session
    email = params[:user][:email]
    password = params[:user][:password]
    if email and password and not (email.blank? or password.blank?)
      if user = User.find_by_email(email) and user.does_password_match?(password)
        session[:user_id] = user.id
        respond_to do |format|
          format.html { redirect_to root_path }
          format.json { render :json => {:status => "success", :redirect_uri => root_path, :user => { :id => user.id, :name => user.name }} }
        end
        
      else
        respond_to do |format|
          format.html { redirect_to login_path, :notice => "Email and password did not match!" }
          format.json { render :json => {:status => "invalid"}, :status => 422 }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to login_path, :notice => "Both email and password are required!" }
        format.json { render :json => {:status => "missing", :email => email.blank?, :password => password.blank?}, :status => 422 }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end
