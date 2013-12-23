AttributedString = require("../../lib/attributedString").AttributedString

describe "AttributedString.RangeNode", ->
  describe "#split", ->
    it "doesn't change the list if the start matches", ->
      node = new AttributedString.RangeNode("some cool", 5, 15)
      result = node.split(5)
      expect(result).toBe node
      expect(result.start).toBe 5
      expect(result.end).toBe 15

    it "breaks the node in two if there's no an exact match", ->
      node = new AttributedString.RangeNode("some cool", 5, 15)
      result = node.split(10)
      expect(result.start).toBe 10
      expect(result.end).toBe 15
      expect(result.nextNode).toBe undefined

      expect(node.nextNode).toBe result

    it "doesn't unlink the chain", ->
      node2 = new AttributedString.RangeNode("some cool", 15, 25)
      node1 = new AttributedString.RangeNode("some cool", 0, 15, node2)

      result = node1.split(10)
      expect(result.start).toBe 10
      expect(result.end).toBe 15
      expect(result.nextNode).toBe node2

      expect(node1.nextNode).toBe result
      expect(node1.end).toBe 10

    it "knows how to traverse the list", ->
      node2 = new AttributedString.RangeNode("some cool", 15, 25)
      node1 = new AttributedString.RangeNode("some cool", 0, 15, node2)
      result = node1.split(20)
      expect(result.start).toBe 20
      expect(result.end).toBe 25
      expect(result.nextNode).toBe undefined
      expect(node2.nextNode).toBe result
      expect(node2.end).toBe 20

  describe "#getNodesLength", ->
    it "should be 1 if there's only one node", ->
      node1 = new AttributedString.RangeNode("some cool", 0, 15)
      expect(node1.getNodesLength()).toBe 1

    it "should be recursive if there's more than one node", ->
      node2 = new AttributedString.RangeNode("some cool", 15, 25)
      node1 = new AttributedString.RangeNode("some cool", 0, 15, node2)

      expect(node1.getNodesLength()).toBe 2

  describe "#toHtml", ->
    it "should wrap itself with a span", ->
      node = new AttributedString.RangeNode("some cool string", 3, 9)
      expect(node.toHtml()).toBe "<span>e cool</span>"


    it "should know how to serialize style attributes", ->
      node = new AttributedString.RangeNode("some cool string", 3, 9)
      node.set "color", "red"
      expect(node.toHtml()).toBe """<span style="color: red">e cool</span>"""
