// [Exposed=Window]
// interface StyleSheet {
//   readonly attribute CSSOMString type;
//   readonly attribute USVString? href;
//   readonly attribute (DOM.Element or ProcessingInstruction)? ownerNode;
//   readonly attribute CSSStyleSheet? parentStyleSheet;
//   readonly attribute DOM.String? title;
//   [SameObject, PutForwards=mediaText] readonly attribute MediaList media;
//   attribute boolean disabled;
// };
import CSS

typealias CSSOMString = String
typealias USVString = String

enum SetUnset {
    case set
    case unset
}

// https://drafts.csswg.org/cssom/#stylesheet
class StyleSheet {
    var type: CSSOMString = ""

    // Specified when created. The absolute-URL string of the first request of
    // the CSS style sheet or null if the CSS style sheet was embedded. Does not
    // change during the lifetime of the CSS style sheet.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-location
    var location: String?

    // Specified when created. The CSS style sheet that is the parent of the CSS
    // style sheet or null if there is no associated parent.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
    var parentStyleSheet: CSSStyleSheet?

    // Specified when created. The DOM node associated with the CSS style sheet
    // or null if there is no associated DOM node.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
    var ownerNode: DOM.Element?

    // Specified when created. The CSS rule in the parent CSS style sheet that
    // caused the inclusion of the CSS style sheet or null if there is no
    // associated rule.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
    var ownerRule: CSS.Rule?

    // Specified when created. The MediaList object associated with the CSS
    // style sheet. If this property is specified to a string, the media must be
    // set to the return value of invoking create a MediaList object steps for
    // that string.
    //
    // If this property is specified to an attribute of the owner node, the media
    // must be set to the return value of invoking create a MediaList object steps
    // for the value of that attribute. Whenever the attribute is set, changed or
    // removed, the media’s mediaText attribute must be set to the new value of the
    // attribute, or to null if the attribute is absent.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
    var media: MediaList? = MediaList()

    // Specified when created. The title of the CSS style sheet, which can be
    // the empty string.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-parent-css-style-sheet
    var title: DOM.String?

    // Specified when created. Either set or unset. Unset by default.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-alternate-flag
    var alternateFlag: SetUnset = .unset

    // Either set or unset. Unset by default.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-disabled-flag
    var disabledFlag: SetUnset = .unset

    // The CSS rules associated with the CSS style sheet.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-css-rules
    var rules: [Rule] = []

    // Specified when created. Either set or unset. If it is set, the API allows
    // reading and modifying of the CSS rules.
    // https://drafts.csswg.org/cssom/#concept-css-style-sheet-origin-clean-flag
    var originCleanFlag: SetUnset = .unset

    // Specified when created. Either set or unset. Unset by default. Signifies
    // whether this stylesheet was created by invoking the IDL-defined
    // constructor.
    var constructedFlag: SetUnset = .unset

    // Either set or unset. Unset by default. If set, modification of the
    // stylesheet’s rules is not allowed.
    var disallowModificationFlag: SetUnset = .unset

    // Specified when created. The Document a constructed stylesheet is
    // associated with. Null by default. Only non-null for stylesheets that have
    // constructed flag set.
    var constructorDocument: DOM.Document?

    // The base URL to use when resolving relative URLs in the stylesheet. Null
    // by default. Only non-null for stylesheets that have constructed flag set.
    var baseURL: String?
}
