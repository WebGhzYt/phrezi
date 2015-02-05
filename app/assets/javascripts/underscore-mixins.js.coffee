# underscore mixins
_.mixin
  noop: -> {},
  keyDebouncers: (->
    debouncers = {}

    (id, fn, duration) ->
      debouncers[id] ||= _.debounce(fn, duration)
  )()
  capitalize : (str) ->
      str.charAt(0).toUpperCase() + str.slice(1).toLowerCase()
  indexOfLambda: (array, fn)->
    return -1 if _.isUndefined(array) || array == null
    for el, i in array
      return i if fn(el)
    return -1
  pending: -> alert("Pending functionality"); false
  remove: (arr, el) ->
    return if !_.isArray(arr)
    index = _.indexOf(arr, el)
    arr.splice(index, 1) if index > -1
  validate: (jquerySelector, validatorFn, message) ->
    $(jquerySelector).each(->
      if !validatorFn.apply(this, [$(this).val()])
        _.setInputErrorMessage(this, message)
        $(jquerySelector).closest('form').data('valid', false)
    )
  setInputErrorMessage: (jquerySelector, message) ->
    $(jquerySelector).closest('.control-group').addClass('error').find(':input').after("<span class='help-inline'>#{message}</span>")
  removeInputErrorMessage: (jquerySelector) ->
    if $(jquerySelector).find(':input').size() > 0
      jquerySelector = $(jquerySelector).find(':input')
    $(jquerySelector).each(->
      $(this).closest('.control-group').removeClass('error').find('span').remove()
    )
  getDay: (date) ->
    day = moment(date).format("dddd")
    if day == 'undefined' then "?" else day
  formatDuration: (duration) ->
    minutes = Math.ceil(duration / 60)
    hours = 0
    if minutes > 60
      hours = Math.floor(minutes / 60)
      minutes -= hours * 60

    format = ""
    format += "#{hours}h" if hours > 0
    format += "#{minutes}m"

  execif: (selector, callback) ->
    jQuery(((selector, callback)->
      (-> callback() if $(selector).size() > 0)
    )(selector, callback))
  noexec: (selector) ->
    $(selector).size() == 0
  #safe get, it has a short name as it is used a lot
  s: (ctx, property, prefix = '', suffix = '')->
    if _.has(ctx, property)
      prefix + ctx[property] + suffix
    else
      ''
  queryString: ->
    result = {}
    queryString = location.search.substring(1)
    re = /([^&=]+)=([^&]*)/g

    while (m = re.exec(queryString))
      result[decodeURIComponent(m[1])] = decodeURIComponent(m[2])

    result

  mergeParamsIntoUrl: (params = {}) ->
    window.location.href.replace(/\?.*$/,'') + "?" + $.param(_.extend({}, _.queryString(), params))

  serialize: (els) ->
    _.inject els, ((memo, x) ->
      name = $(x).attr("name")
      memo[name] = $(x).val()  if name
      memo
    ), {}

  formSerialize: (form) -> _.els $(form).find(":input") , {}

  showMessage: (message, cssClass, selector = "#flash-messages") ->
    body = $(selector)
    body.find(".alert").remove()
    body.prepend("<div class='alert #{cssClass}'>#{message}</div>")
    $('html, body').animate({scrollTop:0}, 'medium', -> (body.animate({opacity: 0.0},'fast', -> $('#flash-messages').animate({opacity: 1.0},'slow'))))

  showInfo: (message, selector) ->
    _.showMessage message, "alert-info", selector

  showSuccess: (message, selector) ->
    _.showMessage message, "alert-success", selector

  showError: (message, selector) ->
    _.showMessage message, "alert-error", selector

  removeErrorMessages: (selector = '#flash-messages') ->
    $(selector).find(".alert").remove()

  selectTag: (opts) ->
    opts = _.defaults(opts, {id: '', selected: '', name: '', prompt : false, cssClass: '', optionsOnly: false, tabindex: false})
    HandlebarsTemplates["backbone/templates/shared/select"](opts)

  nodataRow: (rows, cols = 1, message = "No records found") ->
    if(_.isNumber(rows) && rows < 1)
      HandlebarsTemplates["backbone/templates/shared/no_records_row"]({cols: cols, message: message})

  timestamp: (d) ->
    d ||= new Date()
    _.map([d.getMonth(), d.getDate(), d.getFullYear()], (x) -> _.lpad(x, 0, 2)).join("/") + " " +
      _.map([d.getHours(), d.getMinutes(), d.getSeconds()], (x) -> _.lpad(x, 0, 2)).join(":")

  today: ->
    d = new Date()
    _.lpad(_.lpad(d.getMonth() + 1, 0, 2) + "/" + d.getDate(), 0, 2) + "/" + d.getFullYear()

  lpad: (string, c, length) ->
    if _.isNumber(string) or _.isString(string)
      string = string.toString()
      string = c + string  while padding-- > 0  if (padding = (length - string.length)) > 0
      string

  isEmptyOrBlank: (x) -> _.isUndefined(x) || _.isNull(x) || (_.isString(x) && x.trim().length == 0)

  numberToCurrency: (number, options) ->
    try
      options = options or {}
      precision = options["precision"] or 2
      unit = options["unit"] or "$"
      separator = (if precision > 0 then options["separator"] or "." else "")
      delimiter = options["delimiter"] or ","
      parts = parseFloat(number).toFixed(precision).split(".")
      return unit + _.numberWithDelimiter(parts[0], delimiter) + separator + parts[1].toString()
    catch e
      return number

  formatDay: (date) ->
    if(_.typeof(date) == "String")
      date = new Date(date)
    days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    "#{date.getDate()} (#{days[date.getDay()]})"

  typeof: (obj) ->
    Object.prototype.toString.call(obj).slice(8,-1)

  try: (obj, method) ->
    return undefined unless typeof obj == 'undefined'
    obj[method]

  numberWithDelimiter: (number, options) ->
    try
      options ||= {}
      if (_.isString(number))
        number = +number
      delimiter = options['delimiter'] || ','
      separator = options['separator'] || '.'
      precision = options['precision']
      if _.isNumber(precision)
        number = number.toFixed(precision)
      parts = number.toString().split(".")
      parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter)
      return parts.join(separator)
    catch e
      return number
  slice: (array, n) -> _.groupBy(array, (elm, i) -> Math.floor(i/n))
