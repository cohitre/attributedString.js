export default class AttributedStringNode {
  constructor(string, attributes, next) {
    this.string = string;
    this.attributes = attributes;
    this.next = next;
  }

  attr(name, value) {
    this.attributes = Object.assign(this.attributes, { [name]: value });
  }

  getNodeAtIndex(index) {
    if (index < 0) {
      return null;
    }
    if (index === 0) {
      return this;
    }

    const arrayString = Array.from(this.string);
    const strLength = arrayString.length;

    if (index < strLength) {
      this.next = new AttributedStringNode(
        arrayString.slice(index).join(''), 
        Object.assign({}, this.attributes), 
        this.next
      );
      this.string = arrayString.slice(0, index).join('');
      return this.next;
    }

    if (this.next) {
      return this.next.getNodeAtIndex(index - strLength);
    }

    return null;
  }
}
