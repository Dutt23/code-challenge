class CompaniesController < ApplicationController
  before_action :set_company, except: [:index, :create, :new]

  rescue_from RailsParam::Param::InvalidParameterError do | exception |
   @company = Company.new(company_params)
    @company.errors.add(:error , exception.message)
   render :new 
   end

  def index
    @companies = Company.where( :status => 1)
  end

  def new
    @company = Company.new
  end

  def show
    param! :id, Integer, required: true
    query = "select c.*, l.city, l.state_code from companies c left join locations l on l.id = (select location_id from zip_codes where zip_codes.id = c.location_id)  where c.id = #{params[:id]}"
    @company = Company.find_by_sql(query).first
  end

  def create
    param! :company, Hash, required: true do |record, index|
      record.param! :name, String, required: true, message: "Company name required"
      record.param! :zip_code, String, required: true, message: "Zip code required"
      record.param! :description, String
      record.param! :phone, String 
      record.param! :email, String 
    end
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: "Saved"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      redirect_to companies_path, notice: "Changes Saved"
    else
      render :edit
    end
  end  

  def destroy
    @company.update({
      status: STATUS[:inactive]
    })
    redirect_to companies_path, notice: "#{@company.name} has been successfully deleted"
  end

  private

  def company_params
    params.require(:company).permit(
      :name,
      :legal_name,
      :description,
      :zip_code,
      :phone,
      :email,
      :owner_id,
    )
  end

  def set_company
    @company = Company.find(params[:id])
  end

end
