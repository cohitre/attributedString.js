attributedString.js
====

`attributedString.js` is a simple Javascript String manipulation library that
allows association of attributes with ranges in a string. `AttributedString`
implementations are available in Java and Objective-C, but I couldn't find one
for Javascript.

Attributed strings are very useful when formatting strings for display. While
it is possible to do this kind of transformation using DOM manipulation, this
seems too complicated.

## Usage

    var a = this.aString("Hi friends. This is an attributed string. Isn't it nice?")
    a.range(3, 10).css("text-decoration", "underline")
    a.range(23, 40).css("text-decoration", "underline")
    a.range(23, 33).css("color", "red")
    a.range(34, 40).css("color", "blue")
    console.log(a.toHtml())
    // => <span>Hi </span><span style="text-decoration: underline">friends</span><span>. This is an </span><span style="text-decoration: underline; color: red">attributed</span><span style="text-decoration: underline"> </span><span style="text-decoration: underline; color: blue">string</span><span>. Isn't it nice?</span>
