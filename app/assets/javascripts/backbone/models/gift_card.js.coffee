class LbmGiftCards.Models.GiftCard extends Backbone.Model
  paramRoot: 'gift_card'

  defaults:
    value: null
    user_id: null
    code: null
    state: null
    company_id: null
    expiration_days: null

class LbmGiftCards.Collections.GiftCardsCollection extends Backbone.Collection
  model: LbmGiftCards.Models.GiftCard
  url: '/gift_cards'
