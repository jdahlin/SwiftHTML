// https://html.spec.whatwg.org/multipage/custom-elements.html#look-up-a-custom-element-definition

// Referenced in:
//
// 4.13.1.6 Upgrading elements after their creation
// 4.13.3 Core concepts
// 4.13.4 The CustomElementRegistry interface
// 4.13.5 Upgrades
// 4.13.6 Custom element reactions

struct CustomElementDefinition {
    // A name
    // A valid custom element name
    var name: String

    // A local name
    // A local name
    var localName: String

    // A constructor
    // A Web IDL CustomElementConstructor callback function type value wrapping the custom element constructor

    // A list of observed attributes
    // A sequence<DOMString>
    var observedAttributes: [DOMString]

    // A collection of lifecycle callbacks
    // A map, whose keys are the strings "connectedCallback", "disconnectedCallback", "adoptedCallback", "attributeChangedCallback", "formAssociatedCallback", "formDisabledCallback", "formResetCallback", and "formStateRestoreCallback". The corresponding values are either a Web IDL Function callback function type value, or null. By default the value of each entry is null.
    // A construction stack
    // A list, initially empty, that is manipulated by the upgrade an element algorithm and the HTML element constructors. Each entry in the list will be either an element or an already constructed marker.
    
    // A form-associated boolean
    // If this is true, user agent treats elements associated to this custom element definition as form-associated custom elements.
    var formAssociated: Bool = false

    // A disable internals boolean
    // Controls attachInternals().
    var disableInternals: Bool = false

    // A disable shadow boolean
    // Controls attachShadow().
    var disableShadow: Bool = false

}

extension TreeBuilder {

func lookupCustomElementDefinition(
    document: Document,
    namespace: String,
    localName: String
) -> CustomElementDefinition? {
    // To look up a custom element definition, given a document, namespace,
    // localName, and is, perform the following steps. They will return either a
    // custom element definition or null:

    // 1. If namespace is not the HTML namespace, return null.
    guard namespace == HTML_NS else { return nil }

    // 2. If document's browsing context is null, return null.
    guard document.browsingContext != nil else { return nil }

    // 3. Let registry be document's relevant global object's CustomElementRegistry object.

    // 4. If there is custom element definition in registry with name and local
    //    name both equal to localName, return that custom element definition.

    // 5. If there is a custom element definition in registry with name equal to
    //    is and local name equal to localName, return that custom element
    //    definition.

    // 6. Return null.
    return nil
}

}
