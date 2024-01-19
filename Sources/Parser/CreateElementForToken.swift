extension TreeBuilder {
    // https://html.spec.whatwg.org/multipage/parsing.html#create-an-element-for-the-token
    //
    // Referenced in:
    // 4.13.6 Custom element reactions
    // 8.4 Dynamic markup insertion
    // 13.2.6.1 Creating and inserting nodes
    // 13.2.6.4.2 The "before html" insertion mode
    // 13.2.6.4.4 The "in head" insertion mode
    // 13.2.6.4.7 The "in body" insertion mode (2)
    // 13.2.8 Speculative HTML parsing
    // 14.2 Parsing XML documents

    func createElementForToken(
        token: Token,
        namespace: DOMString,
        intendedParent: Node
    ) -> Element {
        guard case let .startTag(tagName, attributes, _) = token else {
            fatalError("\(#function): unexpected tag: \(token)")
        }

        // 1. If the active speculative HTML parser is not null, then return the
        //    result of creating a speculative mock element given given namespace,
        //    the tag name of the given token, and the attributes of the given
        //    token.
        let result = if activeSpeculativeHTMLParser != nil {
            SpeculativeMockElement(namespace: HTML_NS, tagName: tagName, attributes: attributes)
            // 2. Otherwise, optionally create a speculative mock element given given
            //    namespace, the tag name of the given token, and the attributes of the
            //    given token.
        } else {
            SpeculativeMockElement(namespace: HTML_NS, tagName: tagName, attributes: attributes)
        }
        // Note: The result is not used. This step allows for a speculative fetch to
        //       be initiated from non-speculative parsing. The fetch is still
        //       speculative at this point, because, for example, by the time the
        //       element is inserted, intended parent might have been removed from
        //       the document.
        _ = result

        // 3. Let document be intended parent's node document.
        let document = intendedParent.ownerDocument

        // 4. Let local name be the tag name of the token.
        let localName = tagName

        // 5. Let is be the value of the "is" attribute in the given token, if such
        //    an attribute exists, or null otherwise.
        let is_ = attributes.first(where: { $0.name == "is" })?.value

        // 6. Let definition be the result of looking up a custom element definition
        //    given document, given namespace, local name, and is.

        // 7. If definition is non-null and the parser was not created as part of
        //    the HTML fragment parsing algorithm, then let will execute script be
        //    true. Otherwise, let it be false.

        // 8. If will execute script is true, then:
        if scriptingFlag {
            // 8.1. Increment document's throw-on-dynamic-markup-insertion counter.

            // 8.2 If the JavaScript execution context stack is empty, then perform a
            //     microtask checkpoint.

            // 8.3 Push a new element queue onto document's relevant agent's custom
            //     element reactions stack.
        }

        // 9. Let element be the result of creating an element given document,
        //    localName, given namespace, null, and is. If will execute script is
        //    true, set the synchronous custom elements flag; otherwise, leave it
        //    unset.
        let element = self.document.createElement(
            localName: localName,
            namespace: namespace
        )

        element.namespaceURI = namespace

        // Note: This will cause custom element constructors to run, if will execute
        //       script is true. However, since we incremented the
        //       throw-on-dynamic-markup-insertion counter, this cannot cause new
        //       characters to be inserted into the tokenizer, or the document to be
        //       blown away.

        // 10. Append each attribute in the given token to element.

        // Note: This can enqueue a custom element callback reaction for the
        //       attributeChangedCallback, which might run immediately (in the next
        //       step).

        // Note: Even though the is attribute governs the creation of a customized
        //       built-in element, it is not present during the execution of the
        //       relevant custom element constructor; it is appended in this step,
        //       along with all other attributes.

        // 11. If will execute script is true, then:

        // 11.1. Let queue be the result of popping from document's relevant agent's
        //       custom element reactions stack. (This will be the same element queue
        //       as was pushed above.)

        // 11.2. Invoke custom element reactions in queue.

        // 11.3. Decrement document's throw-on-dynamic-markup-insertion counter.

        // 12. If element has an xmlns attribute in the XMLNS namespace whose value
        //     is not exactly the same as the element's namespace, that is a parse
        //     error. Similarly, if element has an xmlns:xlink attribute in the
        //     XMLNS namespace whose value is not the XLink Namespace, that is a
        //     parse error.

        // 13. If element is a resettable element, invoke its reset algorithm. (This
        //     initializes the element's value and checkedness based on the
        //     element's attributes.)

        // 14. If element is a form-associated element and not a form-associated
        //     custom element, the form element pointer is not null, there is no
        //     template element on the stack of open elements, element is either not
        //     listed or doesn't have a form attribute, and the intended parent is
        //     in the same tree as the element pointed to by the form element
        //     pointer, then associate element with the form element pointed to by
        //     the form element pointer and set element's parser inserted flag.

        // 15. Return element.
        return element
    }
}
