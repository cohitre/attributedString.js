import AttributedStringNode from '../../src/AttributedStringNode';

describe('AttributedStringNode', function() {
  describe('#attr', function() {
    it('adds the attribute to the node', function() {
      const node = new AttributedStringNode('123', {}, null);
      node.attr('color', 'blue');
      expect(node.attributes).toEqual({ color: 'blue' });
    });
  });

  describe('#getNodeAtIndex', function() {
    it('returns null if the index is out of range', function() {
      const node = new AttributedStringNode('123', {}, null);
      expect(node.getNodeAtIndex(-10)).toBe(null);
      expect(node.getNodeAtIndex(10)).toBe(null);
    });

    it('handles emoji characters', function() {
      const node = new AttributedStringNode('👍👍👍👍👍', { color: 'blue' }, null);
      const result = node.getNodeAtIndex(3);
      expect(node.string).toEqual('👍👍👍');
      expect(result.string).toEqual('👍👍');
    });

    it('splits the node if the index is in range', function() {
      const node = new AttributedStringNode('123456789', { color: 'blue' }, null);
      const result = node.getNodeAtIndex(3);
      expect(node.next).toBe(result);
      expect(node.string).toEqual('123');
      expect(node.attributes).toEqual({ color: 'blue' });
      expect(result.string).toEqual('456789');
      expect(result.next).toBe(null);
      expect(result.attributes).toEqual({ color: 'blue' });
      result.attr('color', 'red');
      expect(node.attributes).toEqual({ color: 'blue' });
      expect(result.attributes).toEqual({ color: 'red' });
    });

    it('returns itself if the index is 0', function() {
      const node = new AttributedStringNode('123', {}, null);
      expect(node.getNodeAtIndex(0)).toBe(node);
    });
  });
});