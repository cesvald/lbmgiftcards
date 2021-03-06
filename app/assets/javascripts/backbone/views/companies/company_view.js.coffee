LbmGiftCards.Views.Companies ||= {}

class LbmGiftCards.Views.Companies.CompanyView extends Backbone.View
  template: JST["backbone/templates/companies/company"]

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
