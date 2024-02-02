// 3.1. Page-relative (Physical) Margin Properties: the margin-top, margin-right, margin-bottom, and margin-left properties
// https://drafts.csswg.org/css-box/#margin-physical
// Name:	                margin-top, margin-right, margin-bottom, margin-left
// Value:	                <length-percentage> | auto
// Initial:	                0
// Applies to:	            all elements except internal table elements
// Inherited:	            no
// Percentages:	            refer to logical width of containing block
// Computed value:	        the keyword auto or a computed <length-percentage> value
// Canonical order:	        per grammar
// Animation type:	        by computed value type
// Logical property group:	margin

// 3.2. Margin Shorthand: the margin property
// https://drafts.csswg.org/css-box/#margin-shorthand
// Name:            margin
// Value:	        <'margin-top'>{1,4}
// Initial:	        0
// Applies to:	    see individual properties
// Inherited:	    no
// Percentages:	    refer to logical width of containing block
// Computed value:	see individual properties
// Canonical order:	per grammar
// Animation type:	by computed value type

extension CSS {
    typealias Margin = LengthOrPercentageOrAuto
}

extension CSS.StyleProperties {
    func parseMargin(_ value: CSS.ComponentValue) -> CSS.Margin? {
        CSS.parseLengthOrPercentageOrAuto(value: value)
    }

    func parseMargin(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        let value: CSS.StyleValue? = if let keyword = parseGlobalKeywords(declaration[0]) {
            keyword
        } else if let margin = parseMargin(declaration[0]) {
            .margin(margin)
        } else {
            nil
        }
        return value
    }

    // 3.2. Margin Shorthand: the margin property
    // https://drafts.csswg.org/css-box/#margin-shorthand
    func parseMarginShortHand(context: CSS.ParseContext) {
        let declaration = context.parseDeclaration()
        switch declaration.count {
        // If there is only one component value
        // body { margin: 2em }         /* all margins set to 2em */
        case 1:
            // it applies to all sides.
            if let margin = parseMargin(declaration[0]) {
                marginTop.value = .margin(margin)
                marginRight.value = .margin(margin)
                marginBottom.value = .margin(margin)
                marginLeft.value = .margin(margin)
            }

        // If there are two values,
        // body { margin: 1em 2em }     /* top & bottom = 1em, right & left = 2em */
        case 2:
            // the top and bottom margins are set to the first value and
            // the right and left margins are set to the second.
            if let topBottom = parseMargin(declaration[0]),
               let leftRight = parseMargin(declaration[1])
            {
                marginTop.value = .margin(topBottom)
                marginRight.value = .margin(leftRight)
                marginBottom.value = .margin(topBottom)
                marginLeft.value = .margin(leftRight)
            }

        // If there are three values
        // body { margin: 1em 2em 3em } /* top=1em, right=2em, bottom=3em, left=2em */
        case 3:
            // the top is set to the first value,
            // the left and right are set to the second,
            // and the bottom is set to the third.
            if let top = parseMargin(declaration[0]),
               let leftRight = parseMargin(declaration[1]),
               let bottom = parseMargin(declaration[2])
            {
                marginTop.value = .margin(top)
                marginRight.value = .margin(leftRight)
                marginBottom.value = .margin(bottom)
                marginLeft.value = .margin(leftRight)
            }

        // If there are four values
        // body { margin: 1em 2em 3em 4em } /* top=1em, right=2em, bottom=3em, left=4em */
        case 4:
            // they apply to the top, right, bottom, and left, respectively.
            if let top = parseMargin(declaration[0]),
               let right = parseMargin(declaration[1]),
               let bottom = parseMargin(declaration[2]),
               let left = parseMargin(declaration[3])
            {
                marginTop.value = .margin(top)
                marginRight.value = .margin(right)
                marginBottom.value = .margin(bottom)
                marginLeft.value = .margin(left)
            }

        default:
            break
        }
    }
}
