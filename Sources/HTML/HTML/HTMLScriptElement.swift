// [Exposed=Window]
// interface HTMLScriptElement : HTMLElement {
//   [HTMLConstructor] constructor();

//   [CEReactions] attribute USVString src;
//   [CEReactions] attribute DOM.String type;
//   [CEReactions] attribute boolean noModule;
//   [CEReactions] attribute boolean async;
//   [CEReactions] attribute boolean defer;
//   [CEReactions] attribute DOM.String? crossOrigin;
//   [CEReactions] attribute DOM.String text;
//   [CEReactions] attribute DOM.String integrity;
//   [CEReactions] attribute DOM.String referrerPolicy;
//   [SameObject, PutForwards=value] readonly attribute DOMTokenList blocking;
//   [CEReactions] attribute DOM.String fetchPriority;

//   static boolean supports(DOM.String type);

//   // also has obsolete members
// };
extension HTML {
    class ScriptElement: Element {
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
}
