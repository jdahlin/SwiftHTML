// extension CSS.Properties {
//     // https://drafts.csswg.org/css-box/#margin-shorthand
//     enum MarginShorthand {
//         static let property = CSS.Property<Self>(
//             name: "margin",
//             initial: .one(.length(0))
//         )

//         // If there is only one component value, it applies to all sides.
//         case one(Margin)

//         //  If there are two values, the top and bottom margins are set to the
//         //  first value and the right and left margins are set to the second.
//         case two(topButton: Margin, leftRight: Margin)

//         //  If there are three values, the top is set to the first value, the
//         //  left and right are set to the second, and the bottom is set to the
//         //  third.
//         case three(top: Margin, leftRight: Margin, bottom: Margin)

//         //  If there are four values they apply to the top, right,
//         //  bottom, and left, respectively.
//         case four(top: Margin, right: Margin, bottom: Margin, left: Margin)

//         static func fromString(value: String) -> Self {
//             let tokens = value.split(separator: " ")
//             switch tokens.count {
//             case 1:
//                 return .one(Margin(tokens[0]))
//             case 2:
//                 return .two(topButton: Margin(tokens[0]), leftRight: Margin(tokens[1]))
//             case 3:
//                 return .three(
//                     top: Margin(tokens[0]),
//                     leftRight: Margin(tokens[1]),
//                     bottom: Margin(tokens[2])
//                 )
//             case 4:
//                 return .four(
//                     top: Margin(tokens[0]),
//                     right: Margin(tokens[1]),
//                     bottom: Margin(tokens[2]),
//                     left: Margin(tokens[3])
//                 )
//             default:
//                 return .one(.length(0))
//             }
//         }
//     }
// }
