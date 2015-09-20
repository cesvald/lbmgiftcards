class GiftCardsController < StateController
  
  before_action :set_gift_card, except: [:index, :create, :new, :fisical]

  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:indexs]

  respond_to :html, except: [:redeem, :fisical]
  respond_to :json, only: [:redeem]
  respond_to :pdf, only: [:fisical]

  has_scope :last_gift_cards, :by_company, :by_state

  def index
    expired_gift_cards = GiftCard.expired
    expired_gift_cards.update_all state: 'expired'
    if current_user.admin?
      @gift_cards = apply_scopes(GiftCard).all
    elsif current_user.regular?
      @gift_cards = apply_scopes(GiftCard).where(user: current_user)
    end
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
      rescue ActiveRecord::RecordNotSaved
        @token_attempts = @token_attempts.to_i + 1
        puts "token attempts: " + @token_attempts.to_s
        retry if @token_attempts < @max_retries
        flash[:notice] = 'No fue posible generar un código válido ' + ((params[:number].to_i - total_gift_cards).to_i).to_s
        respond_with @gift_card, location: -> { root_path }
        return
      end
    end
    flash[:notice] = 'The gift cards have been created successfully'
    redirect_to root_path(:last_gift_cards => params[:number].to_i)
  end

  def fisical
    @gift_card = GiftCard.new user: current_user
    authorize @gift_card
    @gift_cards = apply_scopes(GiftCard).all
    @company = @gift_cards.first.company.gift_card_template_url.nil? ? Company.where("gift_card_template IS NOT NULL").first : @gift_cards.first.company
    pdf = WickedPdf.new.pdf_from_string(render_to_string('gift_cards/fisical.html.slim', layout: false))
    save_path = Rails.root.join('','filename.pdf')
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    image = Magick::Image.read('filename.pdf')
    image[0].format = 'JPG'
    image[0].to_blob
    image[0].write('to_file.jpg')
    #render  :pdf => "file.pdf", :template => 'gift_cards/fisical.html.slim', :layout => false
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
