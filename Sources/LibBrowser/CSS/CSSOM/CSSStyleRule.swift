// [Exposed=Window]
// interface CSSStyleRule : CSSGroupingRule {
//   attribute CSSOMString selectorText;
//   [SameObject, PutForwards=cssText] readonly attribute CSSStyleDeclaration style;
// };

extension CSSOM {
    class CSSStyleRule: CSSGroupingRule {
        var selectorList: [CSS.ComplexSelector] = []
        var declarations: CSSOM.CSSStyleDeclaration
        var selector: CSS.Selector {
            CSS.Selector(selectors: selectorList)
        }

        init(qualifiedRule: CSS.QualifiedRule, parentStyleSheet: CSSOM.CSSStyleSheet) {
            let result = qualifiedRule.parse()
            selectorList = result.selectorList
            declarations = CSSOM.CSSStyleDeclaration(items: result.declarations)
            super.init(parentStyleSheet: parentStyleSheet)
        }
    }
}
