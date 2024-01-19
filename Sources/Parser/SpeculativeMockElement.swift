// https://html.spec.whatwg.org/multipage/parsing.html#speculative-mock-element

// A speculative mock element is a struct with the following items:
struct SpeculativeMockElement {
    // A string namespace, corresponding to an element's namespace.
    var namespace: String?

    // A string local name, corresponding to an element's local name.
    var localName: String

    // A list attribute list, corresponding to an element's attribute list.
    var attributes: [Attr]

    // A list children, corresponding to an element's children.
    var children: [Node]
}

extension SpeculativeMockElement {
    // https://html.spec.whatwg.org/multipage/parsing.html#create-a-speculative-mock-element
    //
    // Referenced in
    // - https://html.spec.whatwg.org/multipage/parsing.html#creating-and-inserting-nodes:create-a-speculative-mock-element

    init(namespace: String? = nil, tagName: String, attributes: [Attr]) {
        // To create a speculative mock element given a namespace, tagName, and attributes:

        // Let element be a new speculative mock element.

        // Set element's namespace to namespace.
        self.namespace = namespace

        // Set element's local name to tagName.
        localName = tagName

        // Set element's attribute list to attributes.
        self.attributes = attributes

        // Set element's children to a new empty list.
        children = []

        // Optionally, perform a speculative fetch for element.

        // Return element.
    }
}
