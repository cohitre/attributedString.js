AttributedString = require("../../lib/attributedString").AttributedString

describe "AttributedString.Ranges", ->
  describe "#getText", ->
    it "should join the different text ranges", ->
      str = new AttributedString("cool string")
      str.range(0, 4)
      expect(str.range(2, 6).getText()).toBe "ol s"
