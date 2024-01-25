// [Exposed=Window]
// interface CSSStyleSheet : StyleSheet {
//   constructor(optional CSSStyleSheetInit options = {});

//   readonly attribute CSSRule? ownerRule;
//   [SameObject] readonly attribute CSSRuleList cssRules;
//   unsigned long insertRule(CSSOMString rule, optional unsigned long index = 0);
//   undefined deleteRule(unsigned long index);

//   Promise<CSSStyleSheet> replace(USVString text);
//   undefined replaceSync(USVString text);
// };

// dictionary CSSStyleSheetInit {
//   DOM.String baseURL = null;
//   (MediaList or DOM.String) media = "";
//   boolean disabled = false;
// };

// https://drafts.csswg.org/cssom/#cssstylesheet
class CSSStyleSheet: StyleSheet {}
