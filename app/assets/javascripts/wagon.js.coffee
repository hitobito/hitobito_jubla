#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#

app = window.App ||= {}

app.EventDescription = {
  getDescription: ->
    that = app.EventDescription
    id = $(this).val()
    if that.dataPresent()
      that.insertOrAsk(id)
    else
      $.getJSON( "/event_kinds.json", (data) ->
        that.data = data.event_kinds
        that.insertOrAsk(id)
      )
  
  insertOrAsk: (id) ->
    if this.descriptionEmpty()
      this.fillDescription(id)
    else
      this.showDescriptionLink(id)

  dataPresent: ->
    return typeof this.data != 'undefined'

  fillDescription: (id) ->
    textarea = $('textarea#event_description')
    newTexts = this.data.filter (e) -> e.id == id
    newText = newTexts[0]

    return unless newText?
    return unless newText.general_information?

    spacer = if textarea.val() == "" then "" else " "
    textarea.val(textarea.val() + spacer + newText.general_information)

  descriptionEmpty: ->
    textarea = $('textarea#event_description')
    return textarea.val() == ""

  showDescriptionLink: (id) ->
    this.hideLinks()
    that = this
    input = $('#event_description').parents('.control-group')
    link = $('<div class="controls">
                <span class="help-inline">
                  <a href="#" class="standard-description-link">Standardbeschreibung</a>
                </span>
              </div>');
    
    link.click (e) ->
      e.preventDefault()
      that.fillDescription(id)
      that.hideLinks()

    input.prepend(link)
  
  hideLinks: ->
    $('.standard-description-link').parent().parent().remove();
}

$ ->
  $(document).on('change', 'select#event_kind_id', app.EventDescription.getDescription)
