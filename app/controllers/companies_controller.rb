class CompaniesController < ApplicationController
  before_action :set_company, except: [:index, :create, :new]

  rescue_from RailsParam::Param::InvalidParameterError do | exception |
   @company = Company.new(company_params)
    @company.errors[:base] << exception.message
   render :new 
   end

  def index
    @companies = Company.all
  end

  def new
    @company = Company.new
  end

  def show
  end

  def create
    param! :company, Hash, required: true do |record, index|
      record.param! :name, String, required: true, message: "Company name required"
      record.param! :zip_code, String, required: true, message: "Zip code required"
      record.param! :description, String
      record.param! :phone, String, format: /(?:\+?|\b)[0-9]{10}\b/, message: "Please check your phone number"
      record.param! :email, String, format: /\b[A-Z0-9._%a-z\-]+@getmainstreet\.com\z/, message: "Please check your email"
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
