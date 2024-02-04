extension CSS {
    enum RectangularShorthand<T>: CustomStringConvertible {
        case one(T)
        case two(topBottom: T, leftRight: T)
        case three(top: T, leftRight: T, bottom: T)
        case four(top: T, right: T, bottom: T, left: T)

        var description: String {
            switch self {
            case let .one(value):
                "\(value)"
            case let .two(topBottom, leftRight):
                "\(topBottom) \(leftRight)"
            case let .three(top, leftRight, bottom):
                "\(top) \(leftRight) \(bottom)"
            case let .four(top, right, bottom, left):
                "\(top) \(right) \(bottom) \(left)"
            }
        }
    }
}

extension CSS.StyleProperties {
    func parseColor(context: CSS.ParseContext) -> CSS.StyleValue? {
        let declaration = context.parseDeclaration()
        guard declaration.count == 1 else {
            return nil
        }
        if case let .token(.ident(ident)) = declaration[0] {
            if let named = CSS.Color.Named(string: ident) {
                return .color(.named(named))
            }
            if let system = CSS.Color.System(string: ident) {
                return .color(.system(system))
            }
            FIXME("Don't know how to parse color: \(ident)")
        }
        return nil
    }
}
