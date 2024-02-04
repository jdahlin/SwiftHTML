// 4.1. Page-relative (Physical) Padding Properties: the padding-top,
//      padding-right, padding-bottom, and padding-left properties
// https://drafts.csswg.org/css-box/#padding-physical
// Name:	                padding-top, padding-right, padding-bottom, padding-left
// Value:	                <length-percentage [0,∞]>
// Initial:	                0
// Applies to:	            all elements except: internal table elements other than table cells
// Inherited:	            no
// Percentages:	            refer to logical width of containing block
// Computed value:	        a computed <length-percentage> value
// Canonical order:	        per grammar
// Animation type:	        by computed value type
// Logical property group:

// 4.2. Padding Shorthand: the padding property
// https://drafts.csswg.org/css-box/#padding-shorthand
// Name:	                padding
// Value:	                <'padding-top'>{1,4}
// Initial:	                0
// Applies to:	            see individual properties
// Inherited:	            no
// Percentages:	            refer to logical width of containing block
// Computed value:	        see individual properties
// Canonical order:	        per grammar
// Animation type:	        by computed value type

extension CSS {
    typealias Padding = LengthOrPercentage
}

extension CSS.StyleProperties {
    func parsePadding(_ value: CSS.ComponentValue) -> CSS.StyleValue? {
        CSS.parseLengthOrPercentage(value: value)
    }

    func parsePadding(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        let value: CSS.StyleValue? = if let keyword = parseGlobalKeywords(declaration[0]) {
            keyword
        } else if let padding = parsePadding(declaration[0]) {
            padding
        } else {
            nil
        }
        return value
    }

    func parsePaddingShortHand(context: CSS.ParseContext) {
        let declaration = context.parseDeclaration()
        switch declaration.count {
        // If there is only one component value,
        // body { padding: 2em }         /* all padding set to 2em */
        case 1:
            // it applies to all sides.
            if let padding = parsePadding(declaration[0]) {
                paddingTop.value = padding
                paddingRight.value = padding
                paddingBottom.value = padding
                paddingLeft.value = padding
            }

        // If there are two values,
        // body { padding: 1em 2em }     /* top & bottom = 1em, right & left = 2em */
        case 2:
            // the top and bottom padding are set to the first value and
            // the right and left padding are set to the second.
            if let topBottom = parsePadding(declaration[0]),
               let leftRight = parsePadding(declaration[1])
            {
                paddingTop.value = topBottom
                paddingRight.value = leftRight
                paddingBottom.value = topBottom
                paddingLeft.value = leftRight
            }

        // If there are three values,
        // body { padding: 1em 2em 3em } /* top=1em, right=2em, bottom=3em, left=2em */
        case 3:
            // the top is set to the first value,
            // the left and right are set to the second,
            // and the bottom is set to the third.
            if let top = parsePadding(declaration[0]),
               let leftRight = parsePadding(declaration[1]),
               let bottom = parsePadding(declaration[2])
            {
                paddingTop.value = top
                paddingRight.value = leftRight
                paddingBottom.value = bottom
                paddingLeft.value = leftRight
            }

        // Note: comments missing from spec
        // If there are four values
        // body { padding: 1em 2em 3em 4em } /* top=1em, right=2em, bottom=3em, left=4em */
        case 4:
            // they apply to the top, right, bottom, and left, respectively.
            if let top = parsePadding(declaration[0]),
               let right = parsePadding(declaration[1]),
               let bottom = parsePadding(declaration[2]),
               let left = parsePadding(declaration[3])
            {
                paddingTop.value = top
                paddingRight.value = right
                paddingBottom.value = bottom
                paddingLeft.value = left
            }

        default:
            break
        }
    }
}
