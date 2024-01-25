// interface HTMLElement : DOM.Element {
//   [HTMLConstructor] constructor();

//   // metadata attributes
//   [CEReactions] attribute DOM.String title;
//   [CEReactions] attribute DOM.String lang;
//   [CEReactions] attribute boolean translate;
//   [CEReactions] attribute DOM.String dir;

//   // user interaction
//   [CEReactions] attribute (boolean or unrestricted double or DOM.String)? hidden;
//   [CEReactions] attribute boolean inert;
//   undefined click();
//   [CEReactions] attribute DOM.String accessKey;
//   readonly attribute DOM.String accessKeyLabel;
//   [CEReactions] attribute boolean draggable;
//   [CEReactions] attribute boolean spellcheck;
//   [CEReactions] attribute DOM.String autocapitalize;

//   [CEReactions] attribute [LegacyNullToEmptyString] DOM.String innerText;
//   [CEReactions] attribute [LegacyNullToEmptyString] DOM.String outerText;

//   DOM.ElementInternals attachInternals();

//   // The popover API
//   undefined showPopover();
//   undefined hidePopover();
//   boolean togglePopover(optional boolean force);
//   [CEReactions] attribute DOM.String? popover;
// };

// HTMLElement includes GlobalEventHandlers;
// HTMLElement includes DOM.ElementContentEditable;
// HTMLElement includes HTMLOrSVGDOM.Element;

// [Exposed=Window]
// interface HTMLUnknownDOM.Element : HTMLElement {
//   // Note: intentionally no [HTMLConstructor]

class HTMLElement: DOM.Element {}
