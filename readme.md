attributedString.js
====

`attributedString.js` is a Javascript String manipulation library that allows association of attributes with ranges in a string. 

## Usage
    function unsafeToHtml(attributedString) {
        let unsafeHtmlString = '';
        string.forEach((node) => {
        const style = Object.keys(node.attributes).reduce(((result, key) => result + `${key}: ${node.attributes[key]};`), '');
        unsafeHtmlString += `<span style="${style}">${node.string}</span>`;
        });
        return unsafeHtmlString;
    }

    const originalString = 'Hi friends. This is an attributed string. Isn\'t it nice?';
    const string = new AttributedString(originalString);
    string.range(3, 10).forEach((n) => n.attr('text-decoration', 'underline'));
    string.range(23, 40).forEach((n) => n.attr('text-decoration', 'underline'));
    string.range(23, 33).forEach((n) => n.attr('color', 'red'));
    string.range(34, 40).forEach((n) => n.attr('color', 'blue'));
    console.log(unsafeToHtml(string)); // => <span style="">Hi </span><span style="text-decoration: underline;">friends</span><span style="">. This is an </span><span style="text-decoration: underline;color: red;">attributed</span><span style="text-decoration: underline;"> </span><span style="text-decoration: underline;color: blue;">string</span><span style="">. Isn't it nice?</span>