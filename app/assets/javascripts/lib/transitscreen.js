$('#transitscreen-lightbox').click(function(event) {
  event.preventDefault()

  var $screen = $('#transitscreen')

  $screen.lightbox_me({
    onLoad: function() {
      $screen.css({ height: '540px', width: '960px' })
    }
  })
})
