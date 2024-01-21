// [Exposed=Window]
// interface HTMLStyleElement : HTMLElement {
//   [HTMLConstructor] constructor();

//   attribute boolean disabled;
//   [CEReactions] attribute DOMString media;
//   [SameObject, PutForwards=value] readonly attribute DOMTokenList blocking;

//   // also has obsolete members
// };
// HTMLStyleElement includes LinkStyle;

class HTMLStyleElement: HTMLElement {
    var disabled: Bool = false
    var media: String = ""
}
