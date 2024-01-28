// In order to find the declared values, implementations must first identify all
// declarations that apply to each element. A declaration applies to an element
// if:

// https://www.w3.org/TR/css-cascade-3/#filtering
func findDeclaredValue() {
    // It belongs to a style sheet that currently applies to this document.

    // It is not qualified by a conditional rule [CSS-CONDITIONAL-3] with a false
    // condition.

    // It belongs to a style rule whose selector matches the element. [SELECT]
    // (Taking scoping into account, if necessary.)

    // It is syntactically valid: the declaration’s property is a known property
    // name, and the declaration’s value matches the syntax for that property.

    // The values of the declarations that apply form, for each property on each
    // element, a list of declared values. The next section, the cascade,
    // prioritizes these lists.
}

typealias SelectorSpecificity = UInt16

struct DeclaredValue {
    var cascadeOrigin: CascadeOrigin
    var selectorSpecificity: SelectorSpecificity
    var importance: Bool
}

import Foundation

// https://www.w3.org/TR/css-cascade-3/#cascading
func cascade(declaredValues _: [DeclaredValue]) {
    // The cascade takes an unordered list of declared values for a given
    // property on a given element, sorts them by their declaration’s precedence
    // as determined below, and outputs a single cascaded value.

    // The cascade sorts declarations according to the following criteria, in descending order of priority:
    // let x = declaredValues.sorted(using: [
    // 1. Origin and Importance
    // KeyPathComparator(\.importance, order: .forward),
    // KeyPathComparator(\.cascadeOrigin),
    // // 2. Specificity
    // KeyPathComparator(\.selectorSpecificity),
    // // 3. Order of Appearance
    // KeyPathComparator(\.orderOfAppearance),
    // ])
}

// https://www.w3.org/TR/css-cascade-3/#cascade-origin

// The origin of a declaration is based on where it comes from and its
// importance is whether or not it is declared with !important (see below). The
// precedence of the various origins is, in descending order:

enum CascadeOrigin {
    case userAgent
    case user
    case author
}

// Declarations from origins earlier in this list win over declarations from later origins.
enum CascadeOriginSortOrder: UInt8 {
    // Transition declarations [css-transitions-1]
    case transition = 0

    // Important user agent declarations
    case importantUserAgent = 1

    // Important user declarations
    case importantUser = 2

    // Important author declarations
    case importantAuthor = 3

    // Animation declarations [css-animations-1]
    case animation = 4

    // Normal author declarations
    case normalAuthor = 5

    // Normal user declarations
    case normalUser = 6

    // Normal user agent declarations
    case normalUserAgent = 7
}

// Order of Appearance
// The last declaration in document order wins. For this purpose:

// Declarations from imported style sheets are ordered as if their style sheets
// were substituted in place of the @import rule.

// Declarations from style sheets independently linked by the originating
// document are treated as if they were concatenated in linking order, as
// determined by the host document language.

// Declarations from style attributes are ordered according to the document
// order of the element the style attribute appears on, and are all placed after
// any style sheets.
