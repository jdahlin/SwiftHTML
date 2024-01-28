extension CSS.Color {
    // https://drafts.csswg.org/css-color-4/#named-colors
    enum Named: CustomStringConvertible {
        case aliceblue
        case antiquewhite
        case aqua
        case aquamarine
        case azure
        case beige
        case bisque
        case black
        case blanchedalmond
        case blue
        case blueviolet
        case brown
        case burlywood
        case cadetblue
        case chartreuse
        case chocolate
        case coral
        case cornflowerblue
        case cornsilk
        case crimson
        case cyan
        case darkblue
        case darkcyan
        case darkgoldenrod
        case darkgray
        case darkgreen
        case darkgrey
        case darkkhaki
        case darkmagenta
        case darkolivegreen
        case darkorange
        case darkorchid
        case darkred
        case darksalmon
        case darkseagreen
        case darkslateblue
        case darkslategray
        case darkslategrey
        case darkturquoise
        case darkviolet
        case deeppink
        case deepskyblue
        case dimgray
        case dimgrey
        case dodgerblue
        case firebrick
        case floralwhite
        case forestgreen
        case fuchsia
        case gainsboro
        case ghostwhite
        case gold
        case goldenrod
        case gray
        case green
        case greenyellow
        case grey
        case honeydew
        case hotpink
        case indianred
        case indigo
        case ivory
        case khaki
        case lavender
        case lavenderblush
        case lawngreen
        case lemonchiffon
        case lightblue
        case lightcoral
        case lightcyan
        case lightgoldenrodyellow
        case lightgray
        case lightgreen
        case lightgrey
        case lightpink
        case lightsalmon
        case lightseagreen
        case lightskyblue
        case lightslategray
        case lightslategrey
        case lightsteelblue
        case lightyellow
        case lime
        case limegreen
        case linen
        case magenta
        case maroon
        case mediumaquamarine
        case mediumblue
        case mediumorchid
        case mediumpurple
        case mediumseagreen
        case mediumslateblue
        case mediumspringgreen
        case mediumturquoise
        case mediumvioletred
        case midnightblue
        case mintcream
        case mistyrose
        case moccasin
        case navajowhite
        case navy
        case oldlace
        case olive
        case olivedrab
        case orange
        case orangered
        case orchid
        case palegoldenrod
        case palegreen
        case paleturquoise
        case palevioletred
        case papayawhip
        case peachpuff
        case peru
        case pink
        case plum
        case powderblue
        case purple
        case rebeccapurple
        case red
        case rosybrown
        case royalblue
        case saddlebrown
        case salmon
        case sandybrown
        case seagreen
        case seashell
        case sienna
        case silver
        case skyblue
        case slateblue
        case slategray
        case slategrey
        case snow
        case springgreen
        case steelblue
        case tan
        case teal
        case thistle
        case tomato
        case turquoise
        case violet
        case wheat
        case white
        case whitesmoke
        case yellow
        case yellowgreen

        init(string: String) {
            switch string.lowercased() {
            case "aliceblue": self = .aliceblue
            case "antiquewhite": self = .antiquewhite
            case "aqua": self = .aqua
            case "aquamarine": self = .aquamarine
            case "azure": self = .azure
            case "beige": self = .beige
            case "bisque": self = .bisque
            case "black": self = .black
            case "blanchedalmond": self = .blanchedalmond
            case "blue": self = .blue
            case "blueviolet": self = .blueviolet
            case "brown": self = .brown
            case "burlywood": self = .burlywood
            case "cadetblue": self = .cadetblue
            case "chartreuse": self = .chartreuse
            case "chocolate": self = .chocolate
            case "coral": self = .coral
            case "cornflowerblue": self = .cornflowerblue
            case "cornsilk": self = .cornsilk
            case "crimson": self = .crimson
            case "cyan": self = .cyan
            case "darkblue": self = .darkblue
            case "darkcyan": self = .darkcyan
            case "darkgoldenrod": self = .darkgoldenrod
            case "darkgray": self = .darkgray
            case "darkgreen": self = .darkgreen
            case "darkgrey": self = .darkgrey
            case "darkkhaki": self = .darkkhaki
            case "darkmagenta": self = .darkmagenta
            case "darkolivegreen": self = .darkolivegreen
            case "darkorange": self = .darkorange
            case "darkorchid": self = .darkorchid
            case "darkred": self = .darkred
            case "darksalmon": self = .darksalmon
            case "darkseagreen": self = .darkseagreen
            case "darkslateblue": self = .darkslateblue
            case "darkslategray": self = .darkslategray
            case "darkslategrey": self = .darkslategrey
            case "darkturquoise": self = .darkturquoise
            case "darkviolet": self = .darkviolet
            case "deeppink": self = .deeppink
            case "deepskyblue": self = .deepskyblue
            case "dimgray": self = .dimgray
            case "dimgrey": self = .dimgrey
            case "dodgerblue": self = .dodgerblue
            case "firebrick": self = .firebrick
            case "floralwhite": self = .floralwhite
            case "forestgreen": self = .forestgreen
            case "fuchsia": self = .fuchsia
            case "gainsboro": self = .gainsboro
            case "ghostwhite": self = .ghostwhite
            case "gold": self = .gold
            case "goldenrod": self = .goldenrod
            case "gray": self = .gray
            case "green": self = .green
            case "greenyellow": self = .greenyellow
            case "grey": self = .grey
            case "honeydew": self = .honeydew
            case "hotpink": self = .hotpink
            case "indianred": self = .indianred
            case "indigo": self = .indigo
            case "ivory": self = .ivory
            case "khaki": self = .khaki
            case "lavender": self = .lavender
            case "lavenderblush": self = .lavenderblush
            case "lawngreen": self = .lawngreen
            case "lemonchiffon": self = .lemonchiffon
            case "lightblue": self = .lightblue
            case "lightcoral": self = .lightcoral
            case "lightcyan": self = .lightcyan
            case "lightgoldenrodyellow": self = .lightgoldenrodyellow
            case "lightgray": self = .lightgray
            case "lightgreen": self = .lightgreen
            case "lightgrey": self = .lightgrey
            case "lightpink": self = .lightpink
            case "lightsalmon": self = .lightsalmon
            case "lightseagreen": self = .lightseagreen
            case "lightskyblue": self = .lightskyblue
            case "lightslategray": self = .lightslategray
            case "lightslategrey": self = .lightslategrey
            case "lightsteelblue": self = .lightsteelblue
            case "lightyellow": self = .lightyellow
            case "lime": self = .lime
            case "limegreen": self = .limegreen
            case "linen": self = .linen
            case "magenta": self = .magenta
            case "maroon": self = .maroon
            case "mediumaquamarine": self = .mediumaquamarine
            case "mediumblue": self = .mediumblue
            case "mediumorchid": self = .mediumorchid
            case "mediumpurple": self = .mediumpurple
            case "mediumseagreen": self = .mediumseagreen
            case "mediumslateblue": self = .mediumslateblue
            case "mediumspringgreen": self = .mediumspringgreen
            case "mediumturquoise": self = .mediumturquoise
            case "mediumvioletred": self = .mediumvioletred
            case "midnightblue": self = .midnightblue
            case "mintcream": self = .mintcream
            case "mistyrose": self = .mistyrose
            case "moccasin": self = .moccasin
            case "navajowhite": self = .navajowhite
            case "navy": self = .navy
            case "oldlace": self = .oldlace
            case "olive": self = .olive
            case "olivedrab": self = .olivedrab
            case "orange": self = .orange
            case "orangered": self = .orangered
            case "orchid": self = .orchid
            case "palegoldenrod": self = .palegoldenrod
            case "palegreen": self = .palegreen
            case "paleturquoise": self = .paleturquoise
            case "palevioletred": self = .palevioletred
            case "papayawhip": self = .papayawhip
            case "peachpuff": self = .peachpuff
            case "peru": self = .peru
            case "pink": self = .pink
            case "plum": self = .plum
            case "powderblue": self = .powderblue
            case "purple": self = .purple
            case "rebeccapurple": self = .rebeccapurple
            case "red": self = .red
            case "rosybrown": self = .rosybrown
            case "royalblue": self = .royalblue
            case "saddlebrown": self = .saddlebrown
            case "salmon": self = .salmon
            case "sandybrown": self = .sandybrown
            case "seagreen": self = .seagreen
            case "seashell": self = .seashell
            case "sienna": self = .sienna
            case "silver": self = .silver
            case "skyblue": self = .skyblue
            case "slateblue": self = .slateblue
            case "slategray": self = .slategray
            case "slategrey": self = .slategrey
            case "snow": self = .snow
            case "springgreen": self = .springgreen
            case "steelblue": self = .steelblue
            case "tan": self = .tan
            case "teal": self = .teal
            case "thistle": self = .thistle
            case "tomato": self = .tomato
            case "turquoise": self = .turquoise
            case "violet": self = .violet
            case "wheat": self = .wheat
            case "white": self = .white
            case "whitesmoke": self = .whitesmoke
            case "yellow": self = .yellow
            case "yellowgreen": self = .yellowgreen
            default: self = .black
            }
        }

        func asHex() -> String {
            switch self {
            case .aliceblue: "f0f8ff"
            case .antiquewhite: "faebd7"
            case .aqua: "00ffff"
            case .aquamarine: "7fffd4"
            case .azure: "f0ffff"
            case .beige: "f5f5dc"
            case .bisque: "ffe4c4"
            case .black: "000000"
            case .blanchedalmond: "ffebcd"
            case .blue: "0000ff"
            case .blueviolet: "8a2be2"
            case .brown: "a52a2a"
            case .burlywood: "deb887"
            case .cadetblue: "5f9ea0"
            case .chartreuse: "7fff00"
            case .chocolate: "d2691e"
            case .coral: "ff7f50"
            case .cornflowerblue: "6495ed"
            case .cornsilk: "fff8dc"
            case .crimson: "dc143c"
            case .cyan: "00ffff"
            case .darkblue: "00008b"
            case .darkcyan: "008b8b"
            case .darkgoldenrod: "b8860b"
            case .darkgray: "a9a9a9"
            case .darkgreen: "006400"
            case .darkgrey: "a9a9a9"
            case .darkkhaki: "bdb76b"
            case .darkmagenta: "8b008b"
            case .darkolivegreen: "556b2f"
            case .darkorange: "ff8c00"
            case .darkorchid: "9932cc"
            case .darkred: "8b0000"
            case .darksalmon: "e9967a"
            case .darkseagreen: "8fbc8f"
            case .darkslateblue: "483d8b"
            case .darkslategray: "2f4f4f"
            case .darkslategrey: "2f4f4f"
            case .darkturquoise: "00ced1"
            case .darkviolet: "9400d3"
            case .deeppink: "ff1493"
            case .deepskyblue: "00bfff"
            case .dimgray: "696969"
            case .dimgrey: "696969"
            case .dodgerblue: "1e90ff"
            case .firebrick: "b22222"
            case .floralwhite: "fffaf0"
            case .forestgreen: "228b22"
            case .fuchsia: "ff00ff"
            case .gainsboro: "dcdcdc"
            case .ghostwhite: "f8f8ff"
            case .gold: "ffd700"
            case .goldenrod: "daa520"
            case .gray: "808080"
            case .green: "008000"
            case .greenyellow: "adff2f"
            case .grey: "808080"
            case .honeydew: "f0fff0"
            case .hotpink: "ff69b4"
            case .indianred: "cd5c5c"
            case .indigo: "4b0082"
            case .ivory: "fffff0"
            case .khaki: "f0e68c"
            case .lavender: "e6e6fa"
            case .lavenderblush: "fff0f5"
            case .lawngreen: "7cfc00"
            case .lemonchiffon: "fffacd"
            case .lightblue: "add8e6"
            case .lightcoral: "f08080"
            case .lightcyan: "e0ffff"
            case .lightgoldenrodyellow: "fafad2"
            case .lightgray: "d3d3d3"
            case .lightgreen: "90ee90"
            case .lightgrey: "d3d3d3"
            case .lightpink: "ffb6c1"
            case .lightsalmon: "ffa07a"
            case .lightseagreen: "20b2aa"
            case .lightskyblue: "87cefa"
            case .lightslategray: "778899"
            case .lightslategrey: "778899"
            case .lightsteelblue: "b0c4de"
            case .lightyellow: "ffffe0"
            case .lime: "00ff00"
            case .limegreen: "32cd32"
            case .linen: "faf0e6"
            case .magenta: "ff00ff"
            case .maroon: "800000"
            case .mediumaquamarine: "66cdaa"
            case .mediumblue: "0000cd"
            case .mediumorchid: "ba55d3"
            case .mediumpurple: "9370db"
            case .mediumseagreen: "3cb371"
            case .mediumslateblue: "7b68ee"
            case .mediumspringgreen: "00fa9a"
            case .mediumturquoise: "48d1cc"
            case .mediumvioletred: "c71585"
            case .midnightblue: "191970"
            case .mintcream: "f5fffa"
            case .mistyrose: "ffe4e1"
            case .moccasin: "ffe4b5"
            case .navajowhite: "ffdead"
            case .navy: "000080"
            case .oldlace: "fdf5e6"
            case .olive: "808000"
            case .olivedrab: "6b8e23"
            case .orange: "ffa500"
            case .orangered: "ff4500"
            case .orchid: "da70d6"
            case .palegoldenrod: "eee8aa"
            case .palegreen: "98fb98"
            case .paleturquoise: "afeeee"
            case .palevioletred: "db7093"
            case .papayawhip: "ffefd5"
            case .peachpuff: "ffdab9"
            case .peru: "cd853f"
            case .pink: "ffc0cb"
            case .plum: "dda0dd"
            case .powderblue: "b0e0e6"
            case .purple: "800080"
            case .rebeccapurple: "663399"
            case .red: "ff0000"
            case .rosybrown: "bc8f8f"
            case .royalblue: "4169e1"
            case .saddlebrown: "8b4513"
            case .salmon: "fa8072"
            case .sandybrown: "f4a460"
            case .seagreen: "2e8b57"
            case .seashell: "fff5ee"
            case .sienna: "a0522d"
            case .silver: "c0c0c0"
            case .skyblue: "87ceeb"
            case .slateblue: "6a5acd"
            case .slategray: "708090"
            case .slategrey: "708090"
            case .snow: "fffafa"
            case .springgreen: "00ff7f"
            case .steelblue: "4682b4"
            case .tan: "d2b48c"
            case .teal: "008080"
            case .thistle: "d8bfd8"
            case .tomato: "ff6347"
            case .turquoise: "40e0d0"
            case .violet: "ee82ee"
            case .wheat: "f5deb3"
            case .white: "ffffff"
            case .whitesmoke: "f5f5f5"
            case .yellow: "ffff00"
            case .yellowgreen: "9acd32"
            }
        }

        var description: String {
            asHex()
        }
    }
}
