// [Exposed=Window]
// interface CSSStyleSheet : StyleSheet {
//   constructor(optional CSSStyleSheetInit options = {});

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
extension CSSOM {
    class CSSStyleSheet: StyleSheet {
        // Specified when created. The CSS rule in the parent CSS style sheet that
        // caused the inclusion of the CSS style sheet or null if there is no
        // associated rule.
        // readonly attribute CSSRule? ownerRule;
        // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
        var ownerRule: CSS.Rule?

        // The CSS rules associated with the CSS style sheet.
        // https://drafts.csswg.org/cssom/#concept-css-style-sheet-css-rules
        var rules: [CSSOM.CSSRule] = []

        // [SameObject] readonly attribute CSSRuleList cssRules;
        // var cssRules: CSSRuleList { CSSRuleList(rules) }
    }
}
