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
            selectorList = CSS.consumeSelectorList(qualifiedRule.prelude)
            var tokenStream = CSS.TokenStream(simpleBlock: qualifiedRule.simpleBlock)
            switch Result(catching: { try CSS.parseListOfDeclarations(&tokenStream) }) {
            case let .success(items):
                declarations = CSSOM.CSSStyleDeclaration(items: items)
            case let .failure(error):
                DIE("Handle error: \(error)")
            }
            super.init()
        }
    }
}
