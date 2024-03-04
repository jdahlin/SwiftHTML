

extension CSS {
    struct BorderData: Equatable {
        var color: Color = .transparent
        var style: LineStyle = .none
        var width = CSS.Pixels(0)
    }

    struct LengthBox: Equatable {
        var top: LengthOrPercentageOrAuto = .length(.absolute(.px(0)))
        var right: LengthOrPercentageOrAuto = .length(.absolute(.px(0)))
        var bottom: LengthOrPercentageOrAuto = .length(.absolute(.px(0)))
        var left: LengthOrPercentageOrAuto = .length(.absolute(.px(0)))
    }

    class ComputedValues {
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
        @NonInhertied var boxSizing: CSS.BoxSizing = CSS.InitialValues.boxSizing
        @NonInhertied var inset: CSS.LengthBox = CSS.InitialValues.inset

        func cloneInheritedValues() -> Self {
            let clone = self
            clone.inherited = Inherited()
            return clone
        }

        func inheritFrom(_ parent: ComputedValues) {
            inherited = parent.inherited
        }
    }
}

extension CSS {
    enum InitialValues {
        static let backgroundColor: CSS.Color = .transparent
        static let borderTop: CSS.BorderData = .init()
        static let borderTopColor: CSS.Color = .currentColor
        static let borderTopStyle: CSS.LineStyle = .none
        static let borderTopWidth: CSS.LineWidth = .thickness(.medium)
        static let borderRight: CSS.BorderData = .init()
        static let borderRightColor: CSS.Color = .currentColor
        static let borderRightStyle: CSS.LineStyle = .none
        static let borderRightWidth: CSS.LineWidth = .thickness(.medium)
        static let borderBottom: CSS.BorderData = .init()
        static let borderBottomColor: CSS.Color = .currentColor
        static let borderBottomStyle: CSS.LineStyle = .none
        static let borderBottomWidth: CSS.LineWidth = .thickness(.medium)
        static let borderLeft: CSS.BorderData = .init()
        static let borderLeftColor: CSS.Color = .currentColor
        static let borderLeftStyle: CSS.LineStyle = .none
        static let borderLeftWidth: CSS.LineWidth = .thickness(.medium)
        static let color: CSS.Color = .named(.black)
        static let display: CSS.Display = .init(outer: .inline, inner: .flow)
        static let height: CSS.Size = .auto
        static let width: CSS.Size = .auto
        static let minWidth: CSS.Size = .auto
        static let maxWidth: CSS.Size = .none
        static let minHeight: CSS.Size = .auto
        static let maxHeight: CSS.Size = .none
        static let padding: CSS.LengthBox = .init()
        static let fontSize: CSS.Pixels = .init(16)
        static let insetBlockStart: CSS.Length = .absolute(.px(0))
        static let insetBlockEnd: CSS.Length = .absolute(.px(0))
        static let insetInlineStart: CSS.Length = .absolute(.px(0))
        static let insetInlineEnd: CSS.Length = .absolute(.px(0))
        static let lineHeight: CSS.LineHeight = .normal
        static let margin: CSS.LengthBox = .init()
        static let inset: CSS.LengthBox = .init()
        static let boxSizing: CSS.BoxSizing = .contentBox
        static let outlineColor: CSS.Color = .currentColor
        static let outlineStyle: CSS.LineStyle = .none
        static let outlineWidth: CSS.LineWidth = .thickness(.medium)
    }
}

extension CSS.ComputedValues {
    struct Inherited {}
}
