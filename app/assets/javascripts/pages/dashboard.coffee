(namespace 'HEIConnect.Pages').dashboard =
  init: ->
    $('#status_table .label').popover() if $('#status_table .label').length

  index: ->
    if $('#calendar_data').length
      calendar = new HEIConnect.Widgets.Calendar '#full-calendar', $('#calendar_data').data('events')
      calendar.height = 300
      calendar.minTime = 8
      calendar.maxTime = 21
      calendar.render()

    if $('#average_data').length
      average = new HEIConnect.Widgets.Average 'average-chart', $('#average_data').data('grades'), 'date', ['grade'],
                                               ['Moyenne'], $('#average_data').data('goals')
      average.render()


  courses: ->
    if $('#calendar_data').length
      calendar = new HEIConnect.Widgets.Calendar '#full-calendar', $('#calendar_data').data('events')
      calendar.render()


  grades: ->
    if $('#average_data').length
      average = new HEIConnect.Widgets.Average 'average-chart', $('#average_data').data('grades'), 'date', ['grade'],
                                               ['Moyenne'], $('#average_data').data('goals')
      average.render()