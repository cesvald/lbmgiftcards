LbmGiftCards.Views.GiftCards ||= {}

class LbmGiftCards.Views.GiftCards.GiftCardView extends Backbone.View
  template: JST["backbone/templates/gift_cards/gift_card"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    @$el.html(@template(@model.toJSON() ))
    return this
