LbmGiftCards.Views.Companies ||= {}

class LbmGiftCards.Views.Companies.NewView extends Backbone.View
  template: JST["backbone/templates/companies/new"]

  events:
    "submit #new-company": "save"

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
      success: (company) =>
        @model = company
        window.location.hash = "/#{@model.id}"

      error: (company, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    @$el.html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
