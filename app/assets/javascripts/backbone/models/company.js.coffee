class LbmGiftCards.Models.Company extends Backbone.Model
  paramRoot: 'company'

  defaults:
    name: null
    gift_card_template: null
    code: null

class LbmGiftCards.Collections.CompaniesCollection extends Backbone.Collection
  model: LbmGiftCards.Models.Company
  url: '/companies'
