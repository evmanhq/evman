root = exports ? this

$(document).on 'ready turbolinks:load', ->
  $('input').iCheck({checkboxClass: 'icheckbox_minimal-blue', radioClass: 'iradio_minimal-blue'})