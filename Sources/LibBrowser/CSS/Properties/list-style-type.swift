#if false
    // 3.4 3.4. Text-based Markers: the list-style-type property
    // https://drafts.csswg.org/css-lists/#text-markers
    extension CSS {
        enum ListStyleType: CustomStringConvertible {
            case counter(CounterStyle)
            case string(String)
            case none

            var description: String {
                switch self {
                case let .counter(counter):
                    counter.description
                case let .string(string):
                    string
                case .none:
                    "none"
                }
            }
        }

        static func parseListStyleType(context: ParseContext) -> Property<ListStyleType> {
            let result: ParseResult<ListStyleType> = context.parseGlobal()
            if let property = result.property {
                return property
            }
            let declaration = result.declaration
            let value: PropertyValue<ListStyleType>
            if declaration.count == 1 {
                switch declaration[0] {
                case let .token(.ident(ident)):
                    value = .set(.counter(CounterStyle(value: ident)))
                default:
                    FIXME("\(context.name): \(declaration[0]) not implemented")
                    value = .initial
                }
            } else {
                FIXME("\(context.name): \(declaration) not implemented")
                value = .initial
            }
            return CSS.Property(name: context.name, value: value, important: declaration.important)
        }
    }
#endif
