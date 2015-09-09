LbmGiftCards.Views.GiftCards ||= {}

class LbmGiftCards.Views.GiftCards.NewView extends Backbone.View
  template: JST["backbone/templates/gift_cards/new"]

  events:
    "submit #new-gift_card": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (gift_card) =>
        @model = gift_card
        window.location.hash = "/#{@model.id}"

      error: (gift_card, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
