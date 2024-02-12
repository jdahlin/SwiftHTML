

extension CSS {
    enum LineStyle: Equatable {
        case none
        case hidden
        case dotted
        case dashed
        case solid
        case double
        case groove
        case ridge
        case inset
        case outset
    }

    struct BorderData: Equatable {
        var color: Color = .transparent
        var style: LineStyle = .none
        var width = CSS.Pixels(0)
    }

    struct LengthBox: Equatable {
        var top: LengthOrPercentage = .length(.absolute(.px(0)))
        var right: LengthOrPercentage = .length(.absolute(.px(0)))
        var bottom: LengthOrPercentage = .length(.absolute(.px(0)))
        var left: LengthOrPercentage = .length(.absolute(.px(0)))
    }

    struct ComputedValues {
        @propertyWrapper
        struct NonInhertied<Value> {
            var wrappedValue: Value

            init(wrappedValue: Value) {
                self.wrappedValue = wrappedValue
            }
        }

        var inherited: Inherited = .init()

        @NonInhertied var backgroundColor = CSS.InitialValues.backgroundColor
        @NonInhertied var color = CSS.InitialValues.color
        @NonInhertied var display = CSS.InitialValues.display
        @NonInhertied var height = CSS.InitialValues.height
        @NonInhertied var width = CSS.InitialValues.width
        @NonInhertied var minWidth = CSS.InitialValues.minWidth
        @NonInhertied var maxWidth = CSS.InitialValues.maxWidth
        @NonInhertied var minHeight = CSS.InitialValues.minHeight
        @NonInhertied var maxHeight = CSS.InitialValues.maxHeight
        @NonInhertied var borderTop = CSS.InitialValues.borderTop
        @NonInhertied var borderRight = CSS.InitialValues.borderRight
        @NonInhertied var borderBottom = CSS.InitialValues.borderBottom
        @NonInhertied var borderLeft = CSS.InitialValues.borderLeft
        @NonInhertied var padding = CSS.InitialValues.padding
        @NonInhertied var margin = CSS.InitialValues.margin
        @NonInhertied var fontSize = CSS.InitialValues.fontSize

        func cloneInheritedValues() -> Self {
            var clone = self
            clone.inherited = Inherited()
            return clone
        }

        mutating func apply(style: CSS.StyleProperties) {
            backgroundColor = style.backgroundColor ?? CSS.InitialValues.backgroundColor
            color = style.color ?? CSS.InitialValues.color
            if let display = style.display {
                self.display = display
            }
            if let height = style.height {
                self.height = height
            }
            if let width = style.width {
                self.width = width
            }
            // if let fontSize = style.fontSize {
            //     self.fontSize = style.$fontSize.value?.absolutized()
            // }
        }
    }
}

extension CSS {
    enum InitialValues {
        static let color: CSS.Color = .named(.black)
        static let backgroundColor: CSS.Color = .transparent
        static let display: CSS.Display = .init(outer: .inline, inner: .flow)
        static let height: CSS.Size = .auto
        static let width: CSS.Size = .auto
        static let minWidth: CSS.Size = .auto
        static let maxWidth: CSS.Size = .none
        static let minHeight: CSS.Size = .auto
        static let maxHeight: CSS.Size = .none
        static let borderTop: CSS.BorderData = .init()
        static let borderRight: CSS.BorderData = .init()
        static let borderBottom: CSS.BorderData = .init()
        static let borderLeft: CSS.BorderData = .init()
        static let padding: CSS.LengthBox = .init()
        static let fontSize = CSS.Pixels(16)
        static let insetBlockStart: CSS.Length = .absolute(.px(0))
        static let insetBlockEnd: CSS.Length = .absolute(.px(0))
        static let insetInlineStart: CSS.Length = .absolute(.px(0))
        static let insetInlineEnd: CSS.Length = .absolute(.px(0))
        static let lineHeight: CSS.LineHeight = .normal
        static let margin: CSS.LengthBox = .init()
        static let top = CSS.LengthOrPercentageOrAuto.length(.absolute(.px(0)))
        static let right = CSS.LengthOrPercentageOrAuto.length(.absolute(.px(0)))
        static let bottom = CSS.LengthOrPercentageOrAuto.length(.absolute(.px(0)))
        static let left = CSS.LengthOrPercentageOrAuto.length(.absolute(.px(0)))
    }
}

extension CSS.ComputedValues {
    struct Inherited {}
}
