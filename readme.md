## Usage

    var aString = new AttributedString("Hi friends. This is an attributed string.");
    aString.range(0, 11).color("red");
    aString.range(12, 20).underline();
    aString.toHtml();
