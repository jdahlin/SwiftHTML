// 6.1. Text Alignment: the text-align shorthand
// https://drafts.csswg.org/css-text/#text-align-property
extension CSS {
    enum TextAlign: CustomStringConvertible, EnumStringInit {
        case left
        case right
        case center
        case justify
        case start
        case end
        case matchParent
        case justifyAll

        init(value: String) {
            switch value {
            case "left":
                self = .left
            case "right":
                self = .right
            case "center":
                self = .center
            case "justify":
                self = .justify
            case "start":
                self = .start
            case "end":
                self = .end
            case "match-parent":
                self = .matchParent
            case "justify-all":
                self = .justifyAll
            default:
                DIE("text-align: \(value) not implemented")
            }
        }

        var description: String {
            switch self {
            case .left:
                "left"
            case .right:
                "right"
            case .center:
                "center"
            case .justify:
                "justify"
            case .start:
                "start"
            case .end:
                "end"
            case .matchParent:
                "match-parent"
            case .justifyAll:
                "justify-all"
            }
        }
    }
}
