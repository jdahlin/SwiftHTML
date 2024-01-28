// [Exposed=Window]
// interface CSSStyleRule : CSSGroupingRule {
//   attribute CSSOMString selectorText;
//   [SameObject, PutForwards=cssText] readonly attribute CSSStyleDeclaration style;
// };

extension CSSOM {
    class CSSStyleRule: CSSGroupingRule {
        var selectorList: [CSS.ComplexSelector] = []
        var declarations: CSSOM.CSSStyleDeclaration

        init(qualifiedRule: CSS.QualifiedRule) {
            let result = qualifiedRule.parse()
            selectorList = result.selectorList
            declarations = CSSOM.CSSStyleDeclaration(items: result.declarations)
            super.init()
        }
    }
}
