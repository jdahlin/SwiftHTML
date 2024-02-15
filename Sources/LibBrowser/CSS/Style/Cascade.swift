extension CSS {
    // 6.2. Cascading Origins
    // https://drafts.csswg.org/css-cascade/#cascading-origins
    enum CascadeOrigin: CustomStringConvertible {
        case userAgent
        case user
        case author
        case transition
        case animation

        var description: String {
            switch self {
            case .userAgent: "user agent"
            case .user: "user"
            case .author: "author"
            case .transition: "transition"
            case .animation: "animation"
            }
        }
    }

    // 6.3. Important Declarations: the !important annotation
    // https://drafts.csswg.org/css-cascade/#importance
    static func parseImportant(componentValues: [ComponentValue]) -> (valuesWithoutImportant: [ComponentValue], important: Bool) {
        // A declaration is important if it has a !important annotation as
        // defined by [css-syntax-3], i.e. if the last two (non-whitespace,
        // non-comment) tokens in its value are the delimiter token ! followed
        // by the identifier token important. All other declarations are normal
        // (non-important).
        var componentValues = componentValues
        var important = false

        if componentValues.count >= 2 {
            var index = componentValues.count - 1

            // Remove trailing whitespace and comments
            while index >= 0 {
                let componentValue = componentValues[index]
                if case .token(.whitespace) = componentValue {
                    componentValues.remove(at: index)
                    // } else if case .token(.comment) = componentValue {
                    //     componentValues.remove(at: index)
                } else {
                    break
                }
                index -= 1
            }

            // Check for !important
            if index >= 1,
               case .token(.delim("!")) = componentValues[index - 1],
               case .token(.ident("important")) = componentValues[index]
            {
                important = true
                componentValues.remove(at: index)
                componentValues.remove(at: index - 1)
            }
        }

        return (componentValues, important)
    }
}
