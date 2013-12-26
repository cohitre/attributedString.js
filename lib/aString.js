this.aString = (function () {

var aString
  , StringRange
  , RangesList
  , HtmlSerializer
  , plainStringSerializer
  , _ = {};

_.clone = function (obj) {
  var result = {}
    , key;

  if (obj === undefined || obj === null || typeof obj !== "object") {
    return obj;
  }

  for (key in obj) {
    result[key] = _.clone(obj[key]);
  }
  return result;
};

_.each = function (obj, callback) {
  for (var i in obj) {
    callback.call(obj[i], i, obj[i]);
  }
};

_.stringRangeToArray = function (range, array) {
  array.push({
    text: range.text,
    attributes: range.attributes
  });
  range.next && _.stringRangeToArray(range.next, array);
  return array;
};

_.rangesListApply = function (list, methodName, args) {
  _.each(list.ranges, function (i, obj) {
    obj[methodName].apply(obj, args);
  });
};

aString = function (text) {
  var startNode = new StringRange(text);
  return {
    each: function (callback) {
      var node = startNode
        , index = 0;
      while (node !== undefined) {
        callback.call(this, node, index++);
        node = node.next;
      }
    },
    toArray: function () {
      return _.stringRangeToArray(startNode, []);
    },
    range: function (a, b) {
      var start = Math.min(a, b)
        , end   = Math.max(a, b)
        , node1
        , node2;
      node1 = startNode.split(start);
      node2 = startNode.split(end);
      return RangesList.build(node1, node2);
    },
    getText: function () {
      return plainStringSerializer(startNode, []).join("");
    }
  };
};

StringRange = function (text, next) {
  this.text = text;
  this.next = next;
  this.attributes = {};
};

StringRange.prototype.split = function (index) {
  if (index == 0) {
    return this;
  }
  else if (index < this.text.length) {
    this.next = new StringRange(this.text.slice(index), this.next);
    this.next.attributes = _.clone(this.attributes);
    this.text = this.text.slice(0, index);
    return this.next;
  }
  else {
    if (this.next) {
      return this.next.split(index - this.text.length);
    }
  }
};

StringRange.prototype.css = function (name, val) {
  this.attributes.style = this.attributes.style || {};
  if (arguments.length > 1) {
    this.attributes.style[name] = val;
  }
  else if (name === Object(name)) {
    for (var key in name) {
      this.css(key, name[key]);
    }
  }
  else {
    return this.attributes.style[name];
  }
  return this;
};

StringRange.prototype.attr = function (name, val) {
  if (arguments.length > 1) {
    this.attributes[name] = val;
  }
  else if (name === Object(name)) {
    for (var key in name) {
      this.attr(key, name[key]);
    }
  }
  else {
    return this.attributes[name];
  }
  return this;
};

RangesList = function (ranges) {
  this.ranges = ranges;
};

RangesList.build = function (start, end) {
  var ranges = [];
  while (start !== end) {
    ranges.push(start);
    start = start.next;
  }
  return new RangesList(ranges);
};

RangesList.prototype.get = function (i) {
  return this.ranges[i];
};

RangesList.prototype.attr = function () {
  var args = arguments;
  _.each(this.ranges, function (i, range) {
    range.attr.apply(range, args);
  });
  return this;
};

plainStringSerializer = function (node, array) {
  array.push(node.text);
  node.next && plainStringSerializer(node.next, array);
  return array;
};

return aString;
})();
