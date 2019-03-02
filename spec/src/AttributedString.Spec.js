import AttributedString from '../../src/AttributedString';

describe('AttributedString', function() {
  describe('#rangeForEach', function() {
    it('executes the callback for each item in the range', function() {
      const a = new AttributedString('12👍456789');
      a.rangeForEach(0, 3);
      a.rangeForEach(2, 8);
      const results = [];
      a.rangeForEach(2, 8, (node) => results.push(node.string));
      expect(results).toEqual(['👍', '45678']);
    });

    it('returns an empty range if the indices are outside the string', function() {
      const a = new AttributedString('1234');
      a.rangeForEach(10, 40, (node) => fail('range is not empty'));
      a.rangeForEach(-10, -1, (node) => fail('range is not empty'));
    });
  });

  describe('#forEach', function() {
    it('executes the callback for each range in the string', function() {
      const a = new AttributedString('12👍456789');
      a.rangeForEach(0, 3);
      a.rangeForEach(2, 8);
      const results = [];
      a.forEach((node) => results.push(node.string));
      expect(results).toEqual(['12', '👍', '45678', '9']);
    });
  });
  
  describe('#toString', function() {
    it('returns the string value', function() {
      const a = new AttributedString('');
      expect(a.toString()).toEqual('');
    });

    it('concatenates the nodes as necessary', function() {
      const a = new AttributedString('123456789');
      a.rangeForEach(0, 4);
      a.rangeForEach(2, 8);
      expect(a.toString()).toEqual('123456789');
    });
  });
});