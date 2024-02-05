extension CSS {
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

        func cloneInheritedValues() -> Self {
            var clone = self
            clone.inherited = Inherited()
            return clone
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
    }
}

extension CSS.ComputedValues {
    struct Inherited {}
}
