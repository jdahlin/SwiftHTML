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
            let declarations =
                switch Result { try CSS.parseListOfDeclarations(&tokenStream) } {
                case let .success(items):
                    self.declarations = CSSOM.CSSStyleDeclaration(items: items)
                case let .failure(error):
                    DIE("Handle error: \(error)")
                }
                super.init()
        }
    }
}
