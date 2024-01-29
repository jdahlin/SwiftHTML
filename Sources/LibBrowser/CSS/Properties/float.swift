// 9.5.1. Positioning the float: the float property
// https://drafts.csswg.org/css2/#propdef-float
extension CSS {
    enum FloatValue: CustomStringConvertible, EnumStringInit {
        case left
        case right
        case none

        init(value: String) {
            switch value {
            case "left":
                self = .left
            case "right":
                self = .right
            case "none":
                self = .none
            default:
                FIXME("float: \(value) not implemented")
                self = .none
            }
        }

        var description: String {
            switch self {
            case .left:
                "left"
            case .right:
                "right"
            case .none:
                "none"
            }
        }
    }
}
