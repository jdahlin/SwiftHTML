// https://drafts.csswg.org/cssom/#css-rules
// A CSS rule is an abstract concept that denotes a rule as defined by the CSS
// specification. A CSS rule is represented as an object that implements a
// subclass of the CSSRule interface, and which has the following associated
// state items:

// type
// A non-negative integer associated with a particular type of rule. This item
// is initialized when a rule is created and cannot change.

// text
// A text representation of the rule suitable for direct use in a style sheet.
// This item is initialized when a rule is created and can be changed.

// parent CSS rule
// A reference to an enclosing CSS rule or null. If the rule has an enclosing
// rule when it is created, then this item is initialized to the enclosing rule;
// otherwise it is null. It can be changed to null.

// parent CSS style sheet
// A reference to a parent CSS style sheet or null. This item is initialized to
// reference an associated style sheet when the rule is created. It can be
// changed to null.

// child CSS rules
// A list of child CSS rules. The list can be mutated.

// [Exposed=Window]
// interface CSSRule {
//   attribute CSSOMString cssText;
//   readonly attribute CSSRule? parentRule;
//   readonly attribute CSSStyleSheet? parentStyleSheet;

// the following attribute and constants are historical
//   readonly attribute unsigned short type;
//   const unsigned short STYLE_RULE = 1;
//   const unsigned short CHARSET_RULE = 2;
//   const unsigned short IMPORT_RULE = 3;
//   const unsigned short MEDIA_RULE = 4;
//   const unsigned short FONT_FACE_RULE = 5;
//   const unsigned short PAGE_RULE = 6;
//   const unsigned short MARGIN_RULE = 9;
//   const unsigned short NAMESPACE_RULE = 10;
// };

extension CSSOM {
    class CSSRule {
        var parentStyleSheet: CSSOM.CSSStyleSheet?

        init(parentStyleSheet: CSSOM.CSSStyleSheet) {
            self.parentStyleSheet = parentStyleSheet
        }

        func getDeclaration() -> CSSOM.CSSStyleDeclaration? {
            if let styleRule = self as? CSSOM.CSSStyleRule {
                return styleRule.declarations
            }
            return nil
        }
    }

    static func cssRuleFromRaw(rawRule: CSS.Rule, parentStyleSheet: CSSOM.CSSStyleSheet) -> CSSRule {
        switch rawRule {
        case let .qualified(qualifiedRule):
            CSSStyleRule(qualifiedRule: qualifiedRule, parentStyleSheet: parentStyleSheet)
        default:
            DIE("not implemented: \(rawRule)")
        }
    }
}
