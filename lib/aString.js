this.aString = (function () {

var aString
  , StringRange
  , RangesList
  , HtmlSerializer
  , plainStringSerializer
  , _ = {};

var entityMap = {
  "&": "&amp;",
  "<": "&lt;",
  ">": "&gt;",
  '"': '&quot;',
  "'": '&#39;',
  "/": '&#x2F;'
};

_.escapeHtml = function (string) {
  return String(string).replace(/[&<>"'\/]/g, function (s) {
    return entityMap[s];
  });
};


_.isString = function (obj) {
  return Object.prototype.toString.call(obj) == '[object String]';
}

_.isObject = function (obj) {
  return obj == new Object(obj);
};

_.isArray = function (obj) {
  return Array.isArray(obj);
};

_.clone = function (obj) {
  var result = {};

  if (obj === undefined || obj === null || _.isString(obj) || !_.isObject(obj)) {
    return obj;
  }
  else if (_.isArray(obj)) {
    return _.map(obj.slice(), function (i, obj1) {
      return _.clone(obj1);
    });
  }
  else {
    _.each(obj, function (key, value) {
      result[key] = _.clone(value);
    });
    return result;
  }
};

_.each = function (obj, callback) {
  for (var i in obj) {
    callback.call(obj[i], i, obj[i]);
  }
};

_.map = function (obj, callback) {
  var array = [];
  _.each(obj, function (key, value) {
    array.push(callback(key, value));
  });
  return array;
};

_.stringRangeToArray = function (range, array) {
  array.push({
    text: range.text,
    attributes: range.attributes
  });
  range.next && _.stringRangeToArray(range.next, array);
  return array;
};

_.eachApply = function (ranges, methodName, args) {
  _.each(ranges, function (i, obj) {
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
        callback.call(node, index++, node);
        node = node.next;
      }
    },
    map: function (callback) {
      var array = [];
      this.each(function () {
        array.push(callback.apply(this, arguments));
      });
      return array;
    },
    toArray: function () {
      return _.stringRangeToArray(startNode, []);
    },
    toHtml: function () {
      return this.map(function (i, range) {
        return range.toHtml();
      }).join("");
    },
    range: function (a, b) {
      var start = Math.min(a, b)
        , end   = Math.max(a, b)
        , node1
        , node2;
      node1 = startNode.split(start);
      node2 = node1.split(end - start);
      return RangesList.build(node1, node2);
    },
    getText: function () {
      return this.map(function (i, range) {
        return range.text;
      }).join("");
    }
  };
};

StringRange = function (text, next) {
  this.text = text;
  this.next = next;
  this.attributes = {};
};

StringRange.prototype.toHtml = function () {
  var attributes = _.map(this.attributes, function (key, value) {
    if (key === "style") {
      value = _.map(value, function (style, value) {
        return "" + style + ": " + _.escapeHtml(value);
      }).join("; ");
    }
    return "" + key + '="' + value + '"';
  });

  attributes = attributes.length > 0 ?
    " " + attributes.join(" ") :
    "";

  return ["<span", attributes, ">", _.escapeHtml(this.text), "</span>"].join("");
};

StringRange.prototype.split = function (index) {
  if (index == 0) {
    return this;
  }
  else if (index < this.text.length) {
    var newRange = new StringRange(this.text.slice(index), this.next);
    newRange.attributes = _.clone(this.attributes);
    this.next = newRange;
    this.text = this.text.slice(0, index);
    return newRange;
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

StringRange.prototype.addClass = function (classNames) {
  var array = this.attributes.class || [];
  _.each(classNames.split(" "), function (i, className) {
    array.indexOf(className) < 0 && array.push(className);
  });
  this.attributes.class = array;
  return this;
};

StringRange.prototype.removeClass = function (className) {
  var array = this.attributes.class || []
    , i = array.indexOf(className);

  i >= 0 && array.splice(i, 1);
  this.attributes.class = array;
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

_.each("css attr addClass removeClass".split(" "), function (i, name) {
  RangesList.prototype[name] = function () {
    _.eachApply(this.ranges, name, arguments);
    return this;
  };
});

return aString;
})();
