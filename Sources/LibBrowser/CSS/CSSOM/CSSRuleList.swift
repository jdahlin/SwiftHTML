// [Exposed=Window]
// interface CSSRuleList {
//   getter CSSRule? item(unsigned long index);
//   readonly attribute unsigned long length;
// };

extension CSSOM {
    class CSSRuleList {
        var length: UInt { 0 }
        func item(_: UInt) -> CSSRule? { nil }
    }
}
