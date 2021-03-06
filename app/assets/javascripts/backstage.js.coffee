delay = (->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
)()

ready = ->
  $('body').tooltip(
    selector: '[rel=tooltip]'
    delay: ( show: 250, hide: 500 )
  )

  $('body').popover(
    selector: '[rel=popover]'
    html: true
  ).hover (->
    $('[rel=popover]').css "cursor", "pointer"
  ), ->
    $('[rel=popover]').css "cursor", "auto"

  $('.chosen-select').chosen(
    allow_single_deselect: true
    no_results_text: 'No results matched'
    disable_search_threshold: 10
    width: '100%'
  ).change (event, params)->
    $(this).next('.chosen-has-conflict').removeClass('chosen-has-conflict')
    if $(this).data('check-conflicts') and typeof params != "undefined" and params.hasOwnProperty('selected')
      member_id = params.selected
      show_id = $(this).data('check-conflicts')
      selector = $(this).next('div.chosen-container')
      $.getJSON('/api/members/' + member_id + '/conflicts?for_show=' + show_id).done (json)->
        if json.status == true
          selector.addClass('chosen-has-conflict')
          alert('WARNING: Member has a conflict for this date')

  $('.chosen-reset').click (event)->
    event.preventDefault()
    $('.chosen-select').val('').trigger('chosen:updated').preventDefault

  $("input.datepicker").each ->
    $(this).datepicker
      dateFormat: "yy-mm-dd"
      altField: $(this).next()

  $("input.timepicker").each ->
    $(this).timepicker
      timeFormat: 'g:ia'
      scrollDefaultTime: '8:00pm'
      step: 15

  $('tbody.reposition').sortable(
    axis: 'y'
    handle: '.handle'
    update: ->
      $.post($(this).data('update-url'), $(this).sortable('serialize'))
  )

  # Hide search box when JS is loaded
#  $('#member_search input[type="submit"]').hide();

  # Ajax search on keyup
  $('#member_search input').keyup( ->
    delay (->
      $.get($("#member_search").attr("action"), $("#member_search").serialize(), null, 'script')
      false
    ), 250
  )

$(document).ready(ready)
$(document).on( 'cocoon:after-insert', ready )
