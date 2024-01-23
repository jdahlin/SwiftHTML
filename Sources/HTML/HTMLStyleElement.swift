// [Exposed=Window]
// interface HTMLStyleElement : HTMLElement {
//   [HTMLConstructor] constructor();

//   [SameObject, PutForwards=value] readonly attribute DOMTokenList blocking;

//   // also has obsolete members
// };
// HTMLStyleElement includes LinkStyle;

import CSS

class HTMLStyleElement: HTMLElement {
    // The media attribute says which media the styles apply to. The value must
    // be a valid media query list. The user agent must apply the styles when
    // the media attribute's value matches the environment and the other
    // relevant conditions apply, and must not apply them otherwise.
    //
    // The default, if the media attribute is omitted, is "all", meaning that by
    // default styles apply to all media.
    //
    // Note: The styles might be further limited in scope, e.g. in CSS with the
    //       use of @media blocks. This specification does not override such
    //       further restrictions or requirements.

    // [CEReactions] attribute DOMString media;

    var media: String = "all"

    // attribute boolean disabled;
    // https://html.spec.whatwg.org/multipage/semantics.html#dom-style-disabled
    var disabled: Bool {
        get {
            // 1. If this does not have an associated CSS style sheet, return false.

            // 2. If this's associated CSS style sheet's disabled flag is set, return true.

            // 3. Return false.
            return false
        }
        set {
            // 1. If this does not have an associated CSS style sheet, return.

            // 2. If the given value is true, set this's associated CSS style
            //    sheet's disabled flag. Otherwise, unset this's associated CSS
            //    style sheet's disabled flag.
        }
        // Note: Importantly, disabled attribute assignments only take effect
        //       when the style element has an associated CSS style sheet:
    }

    // https://html.spec.whatwg.org/multipage/semantics.html#update-a-style-block
    func updateStyleBlock() {
        // 1. Let element be the style element.
        let element = self

        // 2. If element has an associated CSS style sheet, remove the CSS style
        //    sheet in question.

        // 3. If element is not connected, then return.

        // 4. If element's type attribute is present and its value is neither
        //    the empty string nor an ASCII case-insensitive match for
        //    "text/css", then return.

        // Note: In particular, a type value with parameters, such as "text/css;
        //        charset=utf-8", will cause this algorithm to return early.

        // 5. If the Should element's inline behavior be blocked by Content
        //    Security Policy? algorithm returns "Blocked" when executed upon
        //    the style element, "style", and the style element's child text
        //    content, then return. [CSP]

        // Create a CSS style sheet with the following properties:
        let cssStyleSheet = CSSStyleSheet()
        // type
        // text/css
        cssStyleSheet.type = "text/css"

        // Owner node
        // element
        cssStyleSheet.ownerNode = element

        // The media attribute of element.
        //
        // Note: This is a reference to the (possibly absent at this time)
        //       attribute, rather than a copy of the attribute's current
        //       value. CSSOM defines what happens when the attribute is
        //       dynamically set, changed, or removed.

        // cssStyleSheet.media = element.getAttribute("media")

        // The title attribute of element, if element is in a document tree,
        // or the empty string otherwise.
        //
        // Note: Again, this is a reference to the attribute.
        cssStyleSheet.title = ""

        // alternate flag
        // Unset.
        cssStyleSheet.alternateFlag = .unset

        // origin-clean flag
        // Set.
        cssStyleSheet.originCleanFlag = .set

        // location
        // parent CSS style sheet
        // owner CSS rule
        // null
        cssStyleSheet.location = nil
        cssStyleSheet.parentStyleSheet = nil
        cssStyleSheet.ownerRule = nil

        // disabled flag
        // Left at its default value.

        // CSS rules
        // Left uninitialized.
        // This doesn't seem right. Presumably we should be using the element's
        // child text content? Tracked as issue #2997.
        let result = Result { try CSS.parseAStylesheet(element.textContent ?? "") }
        switch result {
        case let .success(parsed):
            cssStyleSheet.rules = parsed.rules
        case let .failure(error):
            print(error)
        }

        // 7. If element contributes a script-blocking style sheet, append
        //    element to its node document's script-blocking style sheet set.

        // 8. If element's media attribute's value matches the environment and
        //    element is potentially render-blocking, then block rendering on
        //    element.
    }
}

extension HTMLStyleElement: StackOfOpenElementsNotification {
    func wasRemoved() {
        updateStyleBlock()
    }
}
