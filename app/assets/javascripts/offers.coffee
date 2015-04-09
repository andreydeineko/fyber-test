# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$.api.offers =
    init: ->

        if $.api.action == 'index'

            $offersContainer = $('#offers-container')
            $offers          = $('div#offers')
            $noResults       = $('#no-offers-placeholder')

            $form = $('#offers-form').bind 'ajax:complete', (event, xhr, status) ->
                response = $.parseJSON(xhr.responseText)

                if status == 'success'
                    if response.offers.trim.length > 0
                        $offers.html response.offers
                    else
                        $offers.html ''
                        $noResults.show()
                else
                    $offers.html response.error
