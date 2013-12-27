aString = require("../lib/aString").aString

describe "aString", ->
  describe "#range", ->
    it "should split up the string correctly", ->
      a = aString("a cool string")
      a.range(2, 6).attr("class", "header")
      a.range(0, 4)
      arr = a.toArray()
      expect(arr.length).toBe 4
      expect(arr[0].text).toBe "a "
      expect(arr[1].text).toBe "co"
      expect(arr[1].attributes).toEqual { "class": "header" }
      expect(arr[2].text).toBe "ol"
      expect(arr[2].attributes).toEqual { "class": "header" }
      expect(arr[3].text).toBe " string"

  describe "#toHtml", ->
    it "should call toHtml on each range", ->
      a = aString("a cool string")
      a.range(2, 6).attr("data-class", "header")
      a.range(0, 4).attr("data-href", "#")
      expect(a.toHtml()).toBe '<span data-href="#">a </span><span data-class="header" data-href="#">co</span><span data-class="header">ol</span><span> string</span>'

describe "StringRange", ->
  describe "#attr", ->
    it "should act as a setter and getter", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      expect(range.attr("href")).toBe undefined
      range.attr("href", "#")
      expect(range.attr("href")).toBe "#"

    it "should merge all elements if an object is passed", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.attributes =
        href: "#blue"
        "data-text-decoration": "underline"
      range.attr(
        href: "#red"
      )
      expect(range.attr("href")).toBe "#red"
      expect(range.attr("data-text-decoration")).toBe "underline"

  describe "#css", ->
    it "should act as a setter and getter", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.attributes.style = {}
      expect(range.css("color")).toBe undefined
      range.css("color", "blue")
      expect(range.css("color")).toBe "blue"

    it "should merge all elements if an object is passed", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.attributes.style =
        color: "blue"
        "text-decoration": "underline"
      range.css(
        color: "red"
      )
      expect(range.css("color")).toBe "red"
      expect(range.css("text-decoration")).toBe "underline"

  describe "#addClass", ->
    it "should add the class to the class array only once", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.addClass("cool")
      range.addClass("cool")
      expect(range.attributes.class).toEqual ["cool"]

    it "should split the classes if there are multiple passed", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.addClass("cool bananas")
      expect(range.attributes.class).toEqual ["cool", "bananas"]

  describe "#removeClass", ->
    it "should remove the class from the list", ->
      str = aString("a cool string")
      range = str.range(2, 6).get(0)
      range.addClass("cool")
      range.addClass("cool bananas")
      range.removeClass("cool")
      expect(range.attributes.class).toEqual ["bananas"]
