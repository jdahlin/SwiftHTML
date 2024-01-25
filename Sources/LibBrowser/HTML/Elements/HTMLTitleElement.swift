// https://html.spec.whatwg.org/multipage/semantics.html#htmltitleelement
// [Exposed=Window]
// interface HTMLTitleElement : HTMLElement {
//   [HTMLConstructor] constructor();

//   [CEReactions] attribute DOMString text;
// };

extension HTML {
    class TitleElement: Element {
        var text: String {
            set {
                DIE("TitleElement.text setter not implemented")
            }
            get {
                // Returns the child text content of the element.
                DOM.childTextContent(node: self)
            }
        }
    }
}
