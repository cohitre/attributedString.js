# as = new AttributedString("cool string")
# as.range(0, 100).underline()
# as.range(0, 4).color("red")
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

class AttributedString.Ranges
  constructor: (@ranges) ->

  set: (name, value) ->
    for range in @ranges
      range.set name, value
    @

  underline: ->
    @set "text-decoration", "underline"

  color: (value) ->
    @set "color", value

class AttributedString.RangeNode
  constructor: (@text, @start, @end, @nextNode) ->
    @attributes = {}

  split: (num) ->
    if @start == num
      return @
    else if @start < num && num < @end
      nn = @nextNode
      @nextNode = new AttributedString.RangeNode(@text, num, @end, nn)
      for name, value of @attributes
        @nextNode.attributes[name] = value
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
    @attributes[name] = value

  toHtml: ->
    attributesSerializer = new AttributedString.AttributesSerializer(@attributes)

    "<span#{attributesSerializer.toHtml()}>#{@text.slice(@start, @end)}</span>"

class AttributedString.AttributesSerializer
  STYLE_ATTRIBUTES = ["color", "text-decoration"]
  constructor: (@attributes) ->

  toHtml: ->
    list = []
    style = []

    for key, val of @attributes
      if STYLE_ATTRIBUTES.indexOf(key) >= 0
        style.push "#{key}: #{val}"
      else
        list.push "#{key}=\"#{val}\""

    if style.length > 0
      list.push "style=\"#{style.join("; ")}\""

    if list.length > 0
      " " + list.join(" ")
    else
      ""

@AttributedString = AttributedString
