deepClone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  result = {}
  for key, val of obj
    result[key] = deepClone val

  result

class AttributedString
  constructor: (@text) ->
    @startNode = new AttributedString.RangeNode(@text, 0, @text.length)

  getLength: ->
    @text.length

  getNodesLength: ->
    @startNode.getNodesLength()

  range: (begin, end) ->
    range = @startNode.split(begin)
    range.split(end)
    ranges = []
    while range.end <= end
      ranges.push range
      range = range.nextNode
    new AttributedString.Ranges(ranges)

  toHtml: ->
    serializer = (node, array) ->
      array.push node.toHtml()
      if node.nextNode?
        serializer(node.nextNode, array)
      array

    serializer(@startNode, []).join ""


class AttributedString.Ranges
  constructor: (@ranges) ->

  set: (name, value) ->
    for range in @ranges
      range.set name, value
    @

  attr: (name, value) ->

  css: (k, v) ->
    for range in @ranges
      range.css k, v
    @

  underline: ->
    @css "text-decoration", "underline"
    @

  color: (value) ->
    @css "color", value

class AttributedString.RangeNode
  constructor: (@text, @start, @end, @nextNode) ->
    @attributes = {}

  css: (key, value) ->
    if !@attributes.style?
      @attributes.style = {}
    @attributes.style[key] = value
    @

  split: (num) ->
    if @start == num
      return @
    else if @start < num && num < @end
      nn = @nextNode
      @nextNode = new AttributedString.RangeNode(@text, num, @end, nn)
      @nextNode.attributes = deepClone @attributes
      @end = num
      return @nextNode
    else
      @nextNode.split(num)

  getNodesLength: ->
    if @nextNode == undefined
      return 1
    else
      return @nextNode.getNodesLength() + 1

  getLength: ->
    @end - @start

  set: (name, value) ->
    if value == false
      delete @attributes[name]
    else
      @attributes[name] = value
    @

  toHtml: ->
    attributesSerializer = new AttributedString.AttributesSerializer(@attributes)
    "<span#{attributesSerializer.toHtml()}>#{@text.slice(@start, @end)}</span>"

class AttributedString.AttributesSerializer
  constructor: (@attributes) ->

  serializeStyles: (styles) ->
    style = []
    for key, val of styles
      style.push "#{key}: #{val}"
    style.join "; "

  toHtml: ->
    list = []

    for key, val of @attributes
      if key == "style"
        list.push "style=\"#{@serializeStyles(@attributes.style)}\""
      else
        list.push "#{key}=\"#{val}\""

    if list.length > 0
      " " + list.join(" ")
    else
      ""

@AttributedString = AttributedString
