class CompaniesController < StateController

  before_action :set_company, except: %i[index new create]
  
  after_action :verify_authorized, except: %i[index]
  after_action :verify_policy_scoped, only: %i[index]

  respond_to :html

  def index
    @companies = policy_scope(Company)
    respond_with(@companies)
  end

  def show
    authorize @company
    respond_with @company
  end

  def new
    @company = Company.new user: current_user
    authorize @company
    respond_with @company
  end

  def edit
    authorize @company
    respond_with @company
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    authorize @company
    @company.save
    respond_with @company, location: -> { companies_path }
  end

  def update
    authorize @company
    @company.update(company_params)
    respond_with(@company)
  end

  def destroy
    authorize @company
    @company.destroy
    respond_with @company
  end

  private
    def set_company
      @company = Company.find(params[:id])
    end

    def company_params
      params.require(:company).permit(:name, :gift_card_template, :code)
    end
end