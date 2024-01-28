// extension CSS.Properties {
//     // https://drafts.csswg.org/css-box/#margin-physical
//     enum Margin {
//         static let propertyTop = CSS.Property<Self>(
//             name: "margin-top",
//             initial: .length(0)
//         )
//         static let propertyRight = CSS.Property<Self>(
//             name: "margin-right",
//             initial: .length(0)
//         )

//         static let propertyBottom = CSS.Property<Self>(
//             name: "margin-bottom",
//             initial: .length(0)
//         )
//         static let propertyLeft =
//             CSS.Property<Self>(
//                 name: "margin-left",
//                 initial: .length(0)
//             )

//         case length(Double)
//         case percentage(CSS.Percentage)
//         case auto

//         init(_ value: String) {
//             switch value {
//             case "auto":
//                 self = .auto
//             case let value where value.hasSuffix("%"):
//                 FIXME("Parse percentage: \(value)")
//                 self = .percentage(CSS.Percentage(100))
//             default:
//                 self = .length(Double(value) ?? 0)
//             }
//         }

//         init(_ value: String.SubSequence) {
//             self = Self(String(value))
//         }
//     }
// }
