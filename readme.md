attributedString.js
====

`attributedString.js` is a Javascript String manipulation library that allows association of attributes with ranges in a string. 

## Usage
    const originalString = 'Hi friends. This is an attributed string. Isn\'t it nice?';
    const string = new AttributedString(originalString);
    string.rangeForEach(3, 10, (n) => n.attr('text-decoration', 'underline'));
    string.rangeForEach(23, 40, (n) => n.attr('text-decoration', 'underline'));
    string.rangeForEach(23, 33, (n) => n.attr('color', 'red'));
    string.rangeForEach(34, 40, (n) => n.attr('color', 'blue'));

    function nodeToUnsafeHtmlString(node) {
        const style = Object.keys(node.attributes).reduce(((result, key) => result + `${key}: ${node.attributes[key]};`), '');
        return `<span style="${style}">${node.string}</span>`;
    }

    let unsafeHtmlString = '';
    string.forEach((node) => unsafeHtmlString += nodeToUnsafeHtmlString(node));
    
    console.log(unsafeHtmlString); // => <span style="">Hi </span><span style="text-decoration: underline;">friends</span><span style="">. This is an </span><span style="text-decoration: underline;color: red;">attributed</span><span style="text-decoration: underline;"> </span><span style="text-decoration: underline;color: blue;">string</span><span style="">. Isn't it nice?</span>