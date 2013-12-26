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
