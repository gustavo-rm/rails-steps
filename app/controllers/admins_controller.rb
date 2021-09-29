class AdminsController < ApplicationController
  before_action :set_admin, only: %i[ show edit update destroy ]

  # GET /admins or /admins.json
  def index
    @admins = Admin.all
  end

  # GET /admins/1 or /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    #@admin = Admin.new
    session[:admin_params] ||= {}
    @admin = Admin.new(session[:admin_params])
    @admin.current_step = session[:admin_step]
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins or /admins.json
  # def create
  #  @admin = Admin.new(admin_params)
  #
  # respond_to do |format|
  #   if @admin.save
  #     format.html { redirect_to @admin, notice: "Admin was successfully created." }
  #     format.json { render :show, status: :created, location: @admin }
  #   else
  #     format.html { render :new, status: :unprocessable_entity }
  #     format.json { render json: @admin.errors, status: :unprocessable_entity }
  # end
  #end
  
  def create
    session[:admin_params].deep_merge!(params[:admin].to_unsafe_h) if params[:admin] #deep_merge!(params[:admin]) if params[:admin]
    @admin = Admin.new(session[:admin_params])
    @admin.current_step = session[:admin_step]
    if @admin.valid?
      if params[:back_button]
        @admin.previous_step
      elsif @admin.last_step?
        @admin.save if @admin.all_valid?
      else
        @admin.next_step
      end
      session[:admin_step] = @admin.current_step
    end
    if @admin.new_record?
      render 'new'
    else
      session[:admin_step] = session[:admin_params] = nil
      flash[:notice] = "admin saved."
      redirect_to @admin
    end
  end

  # PATCH/PUT /admins/1 or /admins/1.json
  def update
    respond_to do |format|
      if @admin.update(admin_params)
        format.html { redirect_to @admin, notice: "Admin was successfully updated." }
        format.json { render :show, status: :ok, location: @admin }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admins/1 or /admins/1.json
  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_url, notice: "Admin was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def admin_params
      params.require(:admin).permit(:name, :email, :password, :date_of_birth)
    end
end
