LbmGiftCards.Views.GiftCards ||= {}

class LbmGiftCards.Views.GiftCards.IndexView extends Backbone.View
  template: JST["backbone/templates/gift_cards/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (giftCard) =>
    view = new LbmGiftCards.Views.GiftCards.GiftCardView({model : giftCard})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(giftCards: @collection.toJSON() ))
    @addAll()

    return this
