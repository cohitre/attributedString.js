AttributedString = require("../lib/attributedString").AttributedString

describe "AttributedString", ->
  describe "#constructor", ->
    it "should initialize with a string", ->
      str = new AttributedString("cool string")
      expect(str.text).toBe("cool string")
      expect(str.startNode.start).toBe 0
      expect(str.startNode.end).toBe 11

  describe "#getLength", ->
    it "should return the string length", ->
      str = new AttributedString("1234")
      expect(str.getLength()).toBe 4

  describe "#range", ->
    it "should create a new range", ->
      str = new AttributedString("cool string")
      expect(str.getNodesLength()).toBe 1

      str.range(0, 4)
      expect(str.getNodesLength()).toBe 2

    it "should be able to split ranges", ->
      str = new AttributedString("cool string")
      str.range(0, 4)
      str.range(2, 6)
      expect(str.getNodesLength()).toBe 4

    it "should return a ranges list", ->
      str = new AttributedString("cool string")
      str.range(0, 4)
      list = str.range(2, 6)
      expect(list.ranges.length).toBe 2

  describe "#toHtml", ->
    it "should serialize things", ->
      str = new AttributedString("cool string")
      str.range(0, 4).color "red"
      str.range(2, 6).underline()

      expect(str.toHtml()).toBe '<span style="color: red">co</span><span style="color: red; text-decoration: underline">ol</span><span style="text-decoration: underline"> s</span><span>tring</span>'
