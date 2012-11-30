$ ->
  $('.content p').each ->
    if $(this).text().trim().length < 1 && $(this).children().length < 1
      $(this).hide() 

  if $('body').is('.articles-index, .sources-show')
    loading = false
    $(window).scroll ->
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 400)
        next = $('.next_page')
        url = next.attr('href')
        if !loading && url
          loading = true
          $.get(
            url
            null
            ->
              loading = false
            'script'
          )