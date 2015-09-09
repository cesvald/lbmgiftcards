class LbmGiftCards.Routers.GiftCardsRouter extends Backbone.Router
  initialize: (options) ->
    @giftCards = new LbmGiftCards.Collections.GiftCardsCollection()
    @giftCards.reset options.giftCards

  routes:
    "new"      : "newGiftCard"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newGiftCard: ->
    @view = new LbmGiftCards.Views.GiftCards.NewView(collection: @gift_cards)
    $("#gift_cards").html(@view.render().el)

  index: ->
    @view = new LbmGiftCards.Views.GiftCards.IndexView(collection: @gift_cards)
    $("#gift_cards").html(@view.render().el)

  show: (id) ->
    gift_card = @gift_cards.get(id)

    @view = new LbmGiftCards.Views.GiftCards.ShowView(model: gift_card)
    $("#gift_cards").html(@view.render().el)

  edit: (id) ->
    gift_card = @gift_cards.get(id)

    @view = new LbmGiftCards.Views.GiftCards.EditView(model: gift_card)
    $("#gift_cards").html(@view.render().el)
