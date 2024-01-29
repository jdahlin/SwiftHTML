// 6.2.2. The StyleSheetList Interface
// https://drafts.csswg.org/cssom/#the-stylesheetlist-interface

// [Exposed=Window]
// interface StyleSheetList {
//   getter CSSStyleSheet? item(unsigned long index);
//   readonly attribute unsigned long length;
// };

extension CSSOM {
    class StyleSheetList {
        var styleSheets: [CSSOM.CSSStyleSheet] = []

        var length: UInt {
            UInt(styleSheets.count)
        }

        init(styleSheets: [CSSOM.CSSStyleSheet]) {
            self.styleSheets = styleSheets
        }

        func item(index: UInt) -> CSSOM.CSSStyleSheet? {
            if index < styleSheets.count {
                return styleSheets[Int(index)]
            }
            return nil
        }

        subscript(index: UInt) -> CSSOM.CSSStyleSheet? {
            item(index: index)
        }
    }
}
