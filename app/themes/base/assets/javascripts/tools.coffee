root = exports ? this

$(document).on 'ready turbolinks:load', ->
  $('input').each (input) ->
    return if $(input).parents('.vue-template').length > 0
    $(input).iCheck({checkboxClass: 'icheckbox_minimal-blue', radioClass: 'iradio_minimal-blue'})