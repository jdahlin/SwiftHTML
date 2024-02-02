#if false
    extension CSS {
        struct Image: CustomStringConvertible {
            var description: String {
                "<image>"
            }
        }

        enum ListStylePosition: CustomStringConvertible {
            case inside
            case outside

            var description: String {
                switch self {
                case .inside:
                    "inside"
                case .outside:
                    "outside"
                }
            }
        }

        enum ListStyleImage: CustomStringConvertible {
            case none
            case image(Image)

            var description: String {
                switch self {
                case .none:
                    "none"
                case let .image(image):
                    "\(image)"
                }
            }
        }

        struct ListStyle: CustomStringConvertible {
            var type: ListStyleType = .counter(.predefined(.disc))
            var image: ListStyleImage = .none
            var position: ListStylePosition = .outside

            var description: String {
                var result = ""
                result += type.description

                switch image {
                case .none:
                    break
                case let .image(image):
                    result += " url(\(image))"
                }
                switch position {
                case .inside:
                    result += " inside"
                case .outside:
                    result += " outside"
                }
                return result
            }
        }

        static func parseListStyle(context: ParseContext) -> Property<ListStyle> {
            let result: ParseResult<ListStyle> = context.parseGlobal()
            if let property = result.property {
                return property
            }
            let declaration = result.declaration
            let listStyle = ListStyle()
            let value = PropertyValue<ListStyle>.set(listStyle)

            return CSS.Property(name: context.name, value: value, important: declaration.important)
        }
    }
#endif
