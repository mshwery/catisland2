$ ->
  $('.content p').each ->
    $(this).hide() if $(this).text().trim().length < 1