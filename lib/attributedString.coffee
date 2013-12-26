deepClone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  result = {}
  for key, val of obj
    result[key] = deepClone val

  result

class AttributedString
  constructor: (@text) ->
    @startNode = new AttributedString.RangeNode(@text)

  getNodesLength: ->
    @startNode.getNodesLength()

  range: (a, b) ->
    begin = Math.min(a, b)
    end = Math.max(a, b)
    startRange = @startNode.split(begin)
    endRange = startRange.split(end - begin)
    ranges = []
    while startRange != endRange
      ranges.push startRange
      startRange = startRange.next()
    new AttributedString.Ranges(ranges)

  toObject: ->
    serializer = (node, array) ->
      if node
        array.push(
          text: node.text,
          attributes: node.attributes
        )
        serializer(node.next(), array)
      else
        array

    serializer(@startNode, [])

  toHtml: ->
    serializer = (node, array) ->
      array.push node.toHtml()
      if node.nextNode?
        serializer(node.nextNode, array)
      array

    serializer(@startNode, []).join ""

class AttributedString.Ranges
  constructor: (@ranges) ->

  getText: ->
    strs = for range in @ranges
      range.getText()
    strs.join ""

  getLength: ->
    @ranges.length

  set: (name, value) ->
    for range in @ranges
      range.set name, value
    @

  addClass: (classes) ->
    for range in @ranges
      range.addClass classes
    @

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
  constructor: (@text, @nextNode) ->
    @attributes = {}

  next: ->
    @nextNode

  getText: ->
    @text

  split: (num) ->
    if num == 0
      return @
    else if num < @text.length
      oldNext = @nextNode
      @nextNode = new AttributedString.RangeNode(@text.slice(num), oldNext)
      @nextNode.attributes = deepClone @attributes
      @text = @text.slice(0, num)
      return @nextNode
    else
      return @nextNode.split(num - @text.length)

  getNodesLength: ->
    if @nextNode == undefined
      return 1
    else
      return @nextNode.getNodesLength() + 1

  getLength: ->
    @text.length

  set: (name, value) ->
    if value == false
      delete @attributes[name]
    else
      @attributes[name] = value
    @

  css: (key, value) ->
    if !@attributes.style?
      @attributes.style = {}
    @attributes.style[key] = value
    @

  addClass: (classes) ->
    if @attributes.class?
      @attributes.class += " #{classes}"
    else
      @attributes.class = classes
    @

  toHtml: ->
    attributesSerializer = new AttributedString.AttributesSerializer(@attributes)
    "<span#{attributesSerializer.toHtml()}>#{@text}</span>"

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
