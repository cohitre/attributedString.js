import AttributedStringNode from './AttributedStringNode';

export default class AttributedString {
  constructor(base) {
    this.root = new AttributedStringNode(base, {}, null);
  }

  rangeForEach(indexA, indexB, callback) {
    const startIndex = Math.min(indexA, indexB);
    const endIndex = Math.max(indexA, indexB);
    const startNode = this.root.getNodeAtIndex(startIndex);

    if (startNode === null) {
      return;
    }
    
    const endNode = startNode.getNodeAtIndex(endIndex - startIndex);
    
    if (!callback) {
      return;
    }
    
    let currentNode = startNode;
    while (currentNode != endNode) {
      callback(currentNode);
      currentNode = currentNode.next;
    }
  }

  forEach(callback) {
    let node = this.root;
    while (node) {
      callback(node);
      node = node.next;
    }
  }

  toString() {
    let result = '';
    this.forEach((n) => result += n.string);
    return result;
  }

  toArray() {
    const result = [];
    this.forEach(({ string, attributes }) => result.push({ string, attributes }));
    return result;
  }
}