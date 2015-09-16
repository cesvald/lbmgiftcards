class GiftCardsController < StateController
  
  before_action :set_gift_card, except: [:index, :create, :new]

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  respond_to :html, except: [:redeem]
  respond_to :json, only: [:redeem]

  has_scope :last_gift_cards

  def index
    expired_gift_cards = GiftCard.expired
    expired_gift_cards.update_all state: 'expired'
    @gift_cards = policy_scope(GiftCard)
    respond_with @gift_cards
  end

  def show
    authorize @gift_card
    respond_with @gift_card
  end

  def new
    @gift_card = GiftCard.new user: current_user
    authorize @gift_card
    respond_with @gift_card
  end

  def create
    @gift_card = GiftCard.new(gift_card_params)
    @gift_card.user = current_user
    authorize @gift_card

    total_gift_cards = params[:number].to_i

    if !@gift_card.valid?
      respond_with @gift_card, location: -> { new_gift_card_path }
      return
    end

    @max_retries = total_gift_cards/100 >= 3 ? total_gift_cards/100 * 3 : 3
    while total_gift_cards > 0
      begin
        @gift_card = GiftCard.new(gift_card_params)
        @gift_card.user = current_user
        authorize @gift_card
        @gift_card.save!
        total_gift_cards -= 1
      end
    end
    redirect_to fisical_gift_cards_path(:format => 'pdf', :last_gift_cards => params[:number].to_i, :id => @gift_card.code)
  end

  def fisical
    authorize @gift_card
    @gift_cards = apply_scopes(GiftCard)
    @company = @gift_cards.first.company.gift_card_template_url.nil? ? Company.where("gift_card_template IS NOT NULL").first : @gift_cards.first.company
    p "gift cards size: " + @company.gift_card_template_url
    respond_to do |format|
      format.html do
        render :template => 'gift_cards/fisical.html.slim', :layout => false
      end
      format.pdf do
        render  :pdf => "file.pdf", :template => 'gift_cards/fisical.html.slim', :layout => false
      end
    end
  end

  def edit
    authorize @gift_card
    respond_with @gift_card
  end

  def update
    authorize @gift_card
    @gift_card.update(gift_card_params)
    respond_with @gift_card
  end

  def destroy
    authorize @gift_card
    @gift_card.destroy
    respond_with @gift_card
  end

  def redeem
    authorize @gift_card
    return render json: { error: 'no_value', message: t('.no_value') }, status: 422 unless params[:value].present?
    return render json: { error: 'wrong_value', message: t('.wrong_value') }, status: 422 unless params[:value].to_i == @gift_card.value.to_i
    if @gift_card.state?(:pending) && @gift_card.expiration_date < Date.today
      @gift_card.expire!
      return render json: { error: 'expired', message: t('.expired') }, status: 422
    end
    return render json: { error: 'expired', message: t('.expired') }, status: 422 if @gift_card.state?(:expired)
    return render json: { error: 'cant_redeem', message: t('.cant_redeem') }, status: 422 unless @gift_card.can_redeem?
    transition_state(:redeem)
  end

  def invalidate
    transition_state(:invalidate)
  end

  private

  def gift_card_params
    params.require(:gift_card).permit(:value, :expiration_date, :company_id)
  end

  def set_gift_card
    @gift_card = GiftCard.find_by_code!(params[:id])
  end

  def transition_state(transition)
    super(@gift_card, transition, root_path)
  end

end
