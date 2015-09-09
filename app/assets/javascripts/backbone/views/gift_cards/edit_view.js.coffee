LbmGiftCards.Views.GiftCards ||= {}

class LbmGiftCards.Views.GiftCards.EditView extends Backbone.View
  template: JST["backbone/templates/gift_cards/edit"]

  events:
    "submit #edit-gift_card": "update"

  update: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success: (gift_card) =>
        @model = gift_card
        window.location.hash = "/#{@model.id}"
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
