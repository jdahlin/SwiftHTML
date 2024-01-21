// [Exposed=Window]
// interface HTMLScriptElement : HTMLElement {
//   [HTMLConstructor] constructor();

//   [CEReactions] attribute USVString src;
//   [CEReactions] attribute DOMString type;
//   [CEReactions] attribute boolean noModule;
//   [CEReactions] attribute boolean async;
//   [CEReactions] attribute boolean defer;
//   [CEReactions] attribute DOMString? crossOrigin;
//   [CEReactions] attribute DOMString text;
//   [CEReactions] attribute DOMString integrity;
//   [CEReactions] attribute DOMString referrerPolicy;
//   [SameObject, PutForwards=value] readonly attribute DOMTokenList blocking;
//   [CEReactions] attribute DOMString fetchPriority;

//   static boolean supports(DOMString type);

//   // also has obsolete members
// };

class HTMLScriptElement: HTMLElement {
    var src: String = ""
    var type: String = ""
    var noModule: Bool = false
    var async: Bool = false
    var defer_: Bool = false
    var crossOrigin: String? = nil
    var text: String = ""
    var integrity: String = ""
    var referrerPolicy: String = ""
    var fetchPriority: String = ""
}
