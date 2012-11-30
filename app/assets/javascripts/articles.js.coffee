$ ->
  $('.content p').each ->
    $(this).hide() if $(this).text().trim().length < 1

  if $('body').hasClass('articles-index')
    loading = false
    $(window).scroll ->
      if ($(window).scrollTop() >= $(document).height() - $(window).height() - 100)
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