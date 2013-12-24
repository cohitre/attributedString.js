AttributedString = require("../../lib/attributedString").AttributedString

describe "AttributedString.RangeNode", ->
  describe "#split", ->
    it "doesn't change the node if the index is 0", ->
      node = new AttributedString.RangeNode("some cool")
      result = node.split(0)
      expect(result).toBe node

    it "splits the node if the index is under the length", ->
      node = new AttributedString.RangeNode("some cool")
      node.split(4)
      expect(node.text).toBe "some"
      expect(node.next().text).toBe " cool"


    it "delegates to the next node if the index is over the text length", ->
      node = new AttributedString.RangeNode("some cool", new AttributedString.RangeNode(" string"))
      result = node.split(10)
      expect(node.text).toBe "some cool"
      expect(node.next().text).toBe " "
      expect(result.text).toBe "string"

  describe "#getNodesLength", ->
    it "should be 1 if there's only one node", ->
      node1 = new AttributedString.RangeNode("some cool")
      expect(node1.getNodesLength()).toBe 1

    it "should be recursive if there's more than one node", ->
      node2 = new AttributedString.RangeNode(" string")
      node1 = new AttributedString.RangeNode("some cool", node2)
      expect(node1.getNodesLength()).toBe 2

  describe "#toHtml", ->
    it "should wrap itself with a span", ->
      node = new AttributedString.RangeNode("some cool")
      expect(node.toHtml()).toBe "<span>some cool</span>"

    it "should know how to serialize style attributes", ->
      node = new AttributedString.RangeNode("some cool")
      node.css "color", "red"
      expect(node.toHtml()).toBe """<span style="color: red">some cool</span>"""
