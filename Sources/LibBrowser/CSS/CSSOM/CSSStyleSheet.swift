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
        var cssRules: CSSRuleList { CSSRuleList(rules: rules) }

        var styleRules: [CSSOM.CSSStyleRule] {
            cssRules.compactMap { $0 as? CSSOM.CSSStyleRule }
        }

        func loadRules(content: String) {
            let result = Result { try CSS.parseAStylesheet(data: content) }
            switch result {
            case let .success(parsed):
                rules = parsed.rules.map { CSSOM.cssRuleFromRaw(rawRule: $0, parentStyleSheet: self) }
            case let .failure(error):
                print(error)
            }
        }
    }
}
