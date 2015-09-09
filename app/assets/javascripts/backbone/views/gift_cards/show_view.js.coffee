LbmGiftCards.Views.GiftCards ||= {}

class LbmGiftCards.Views.GiftCards.ShowView extends Backbone.View
  template: JST["backbone/templates/gift_cards/show"]

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
