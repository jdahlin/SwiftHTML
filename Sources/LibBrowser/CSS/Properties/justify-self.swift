// 6.1. Inline-Axis (or Main-Axis) Alignment: the justify-self property
// https://drafts.csswg.org/css-align/#justify-self-property
extension CSS {
    enum JustifySelf: CustomStringConvertible, EnumStringInit {
        case auto
        case normal
        case stretch
        case first
        case last
        case safe
        case unsafe
        case center
        case start
        case end
        case selfStart
        case selfEnd
        case flexStart
        case flexEnd
        case left
        case right

        init?(value: String) {
            switch value {
            case "auto":
                self = .auto
            case "normal":
                self = .normal
            case "stretch":
                self = .stretch
            case "first":
                self = .first
            case "last":
                self = .last
            case "safe":
                self = .safe
            case "unsafe":
                self = .unsafe
            case "center":
                self = .center
            case "start":
                self = .start
            case "end":
                self = .end
            case "self-start":
                self = .selfStart
            case "self-end":
                self = .selfEnd
            case "flex-start":
                self = .flexStart
            case "flex-end":
                self = .flexEnd
            case "left":
                self = .left
            case "right":
                self = .right
            default:
                return nil
            }
        }

        var description: String {
            switch self {
            case .auto:
                "auto"
            case .normal:
                "normal"
            case .stretch:
                "stretch"
            case .first:
                "first"
            case .last:
                "last"
            case .safe:
                "safe"
            case .unsafe:
                "unsafe"
            case .center:
                "center"
            case .start:
                "start"
            case .end:
                "end"
            case .selfStart:
                "self-start"
            case .selfEnd:
                "self-end"
            case .flexStart:
                "flex-start"
            case .flexEnd:
                "flex-end"
            case .left:
                "left"
            case .right:
                "right"
            }
        }
    }
}
