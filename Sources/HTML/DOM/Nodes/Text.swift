// https://dom.spec.whatwg.org/#interface-text

// [Exposed=Window]
// interface Text : CharacterData {
//   constructor(optional DOMString data = "");
//
//   [NewObject] Text splitText(unsigned long offset);
//   readonly attribute DOMString wholeText;
// };

class Text: CharacterData {
    init(data: DOMString = "", ownerDocument: Document? = nil) {
        super.init(ownerDocument: ownerDocument)
        self.data = data
    }
}

// The descendant text content of a node node is the concatenation of the data
// of all the Text node descendants of node, in tree order.
// https://dom.spec.whatwg.org/#concept-descendant-text-content
func descendantTextContent(node: Node) -> String {
    var textContent = ""

    if let textNode = node as? Text {
        textContent += textNode.data
    }

    for childNode in node.childNodes {
        textContent += descendantTextContent(node: childNode)
    }

    return textContent
}
