// [Exposed=Window]
// interface CSSRuleList {
//   getter CSSRule? item(unsigned long index);
//   readonly attribute unsigned long length;
// };

extension CSSOM {
    class CSSRuleList: Sequence {
        var rules: [CSSOM.CSSRule] = []
        var length: UInt { UInt(rules.count) }

        init(rules: [CSSOM.CSSRule]) {
            self.rules = rules
        }

        func item(index: UInt) -> CSSOM.CSSRule? {
            if index < rules.count {
                return rules[Int(index)]
            }
            return nil
        }

        subscript(index: UInt) -> CSSOM.CSSRule? {
            item(index: index)
        }

        func makeIterator() -> IndexingIterator<[CSSOM.CSSRule]> {
            rules.makeIterator()
        }
    }
}
