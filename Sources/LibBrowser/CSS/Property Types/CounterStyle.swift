// https://drafts.csswg.org/css-counter-styles-3/#typedef-counter-style
extension CSS {
    enum CounterStyle: CustomStringConvertible, EnumStringInit {
        case predefined(PredefinedCounterStyle)
        case symbols(String)

        var description: String {
            switch self {
            case let .predefined(style):
                style.description
            case let .symbols(symbols):
                "symbols(\(symbols))"
            }
        }

        init(value: String) {
            let predefined = PredefinedCounterStyle(value: value)
            self = .predefined(predefined)
        }

        enum PredefinedCounterStyle: CustomStringConvertible, EnumStringInit {
            // simple numeric
            // https://drafts.csswg.org/css-counter-styles-3/#simple-numeric
            case decimal
            case decimalLeadingZero
            case arabicIndic
            case armenian
            case upperArmenian
            case lowerArmenian
            case bengali
            case cambodian
            case khmer
            case cjkDecimal
            case devanagari
            case georgian
            case gujarati
            case gurmukhi
            case hebrew
            case kannada
            case lao
            case malayalam
            case mongolian
            case myanmar
            case oriya
            case persian
            case lowerRoman
            case upperRoman
            case tamil
            case telugu
            case thai
            case tibetan
            // simple alphabet
            // https://drafts.csswg.org/css-counter-styles-3/#simple-alphabetic
            case lowerAlpha
            case upperAlpha
            case lowerLatin
            case upperLatin
            case lowerGreek
            case upperGreek
            case hiragana
            case hiraganaIroha
            case katakana
            case katakanaIroha
            // simple symbolic
            // https://drafts.csswg.org/css-counter-styles-3/#simple-symbolic
            case disc
            case circle
            case square
            case disclosureOpen
            case disclosureClosed
            // simple fixed
            // https://drafts.csswg.org/css-counter-styles-3/#simple-fixed
            case cjkEarthlyBranch
            case cjkHeavenlyStem
            // Complex
            // https://drafts.csswg.org/css-counter-styles-3/#complex-predefined-counters
            case japaneseInformal
            case japaneseFormal
            case koreanHangulFormal
            case koreanHanjaInformal
            case koreanHanjaFormal
            case simpChineseInformal
            case simpChineseFormal
            case tradChineseInformal
            case tradChineseFormal
            case ethiopicNumeric

            var description: String {
                switch self {
                case .decimal:
                    "decimal"
                case .decimalLeadingZero:
                    "decimal-leading-zero"
                case .arabicIndic:
                    "arabic-indic"
                case .armenian:
                    "armenian"
                case .upperArmenian:
                    "upper-armenian"
                case .lowerArmenian:
                    "lower-armenian"
                case .bengali:
                    "bengali"
                case .cambodian:
                    "cambodian"
                case .khmer:
                    "khmer"
                case .cjkDecimal:
                    "cjk-decimal"
                case .devanagari:
                    "devanagari"
                case .georgian:
                    "georgian"
                case .gujarati:
                    "gujarati"
                case .gurmukhi:
                    "gurmukhi"
                case .hebrew:
                    "hebrew"
                case .kannada:
                    "kannada"
                case .lao:
                    "lao"
                case .malayalam:
                    "malayalam"
                case .mongolian:
                    "mongolian"
                case .myanmar:
                    "myanmar"
                case .oriya:
                    "oriya"
                case .persian:
                    "persian"
                case .lowerRoman:
                    "lower-roman"
                case .upperRoman:
                    "upper-roman"
                case .tamil:
                    "tamil"
                case .telugu:
                    "telugu"
                case .thai:
                    "thai"
                case .tibetan:
                    "tibetan"
                case .lowerAlpha:
                    "lower-alpha"
                case .upperAlpha:
                    "upper-alpha"
                case .lowerLatin:
                    "lower-latin"
                case .upperLatin:
                    "upper-latin"
                case .lowerGreek:
                    "lower-greek"
                case .upperGreek:
                    "upper-greek"
                case .hiragana:
                    "hiragana"
                case .hiraganaIroha:
                    "hiragana-iroha"
                case .katakana:
                    "katakana"
                case .katakanaIroha:
                    "katakana-iroha"
                case .disc:
                    "disc"
                case .circle:
                    "circle"
                case .square:
                    "square"
                case .disclosureOpen:
                    "disclosure-open"
                case .disclosureClosed:
                    "disclosure-closed"
                case .cjkEarthlyBranch:
                    "cjk-earthly-branch"
                case .cjkHeavenlyStem:
                    "cjk-heavenly-stem"
                case .japaneseInformal:
                    "japanese-informal"
                case .japaneseFormal:
                    "japanese-formal"
                case .koreanHangulFormal:
                    "korean-hangul-formal"
                case .koreanHanjaInformal:
                    "korean-hanja-informal"
                case .koreanHanjaFormal:
                    "korean-hanja-formal"
                case .simpChineseInformal:
                    "simp-chinese-informal"
                case .simpChineseFormal:
                    "simp-chinese-formal"
                case .tradChineseInformal:
                    "trad-chinese-informal"
                case .tradChineseFormal:
                    "trad-chinese-formal"
                case .ethiopicNumeric:
                    "ethiopic-numeric"
                }
            }

            init(value: String) {
                switch value {
                case "decimal":
                    self = .decimal
                case "decimal-leading-zero":
                    self = .decimalLeadingZero
                case "arabic-indic":
                    self = .arabicIndic
                case "armenian":
                    self = .armenian
                case "upper-armenian":
                    self = .upperArmenian
                case "lower-armenian":
                    self = .lowerArmenian
                case "bengali":
                    self = .bengali
                case "cambodian":
                    self = .cambodian
                case "khmer":
                    self = .khmer
                case "cjk-decimal":
                    self = .cjkDecimal
                case "devanagari":
                    self = .devanagari
                case "georgian":
                    self = .georgian
                case "gujarati":
                    self = .gujarati
                case "gurmukhi":
                    self = .gurmukhi
                case "hebrew":
                    self = .hebrew
                case "kannada":
                    self = .kannada
                case "lao":
                    self = .lao
                case "malayalam":
                    self = .malayalam
                case "mongolian":
                    self = .mongolian
                case "myanmar":
                    self = .myanmar
                case "oriya":
                    self = .oriya
                case "persian":
                    self = .persian
                case "lower-roman":
                    self = .lowerRoman
                case "upper-roman":
                    self = .upperRoman
                case "tamil":
                    self = .tamil
                case "telugu":
                    self = .telugu
                case "thai":
                    self = .thai
                case "tibetan":
                    self = .tibetan
                case "lower-alpha":
                    self = .lowerAlpha
                case "upper-alpha":
                    self = .upperAlpha
                case "lower-latin":
                    self = .lowerLatin
                case "upper-latin":
                    self = .upperLatin
                case "lower-greek":
                    self = .lowerGreek
                case "upper-greek":
                    self = .upperGreek
                case "hiragana":
                    self = .hiragana
                case "hiragana-iroha":
                    self = .hiraganaIroha
                case "katakana":
                    self = .katakana
                case "katakana-iroha":
                    self = .katakanaIroha
                case "disc":
                    self = .disc
                case "circle":
                    self = .circle
                case "square":
                    self = .square
                case "disclosure-open":
                    self = .disclosureOpen
                case "disclosure-closed":
                    self = .disclosureClosed
                case "cjk-earthly-branch":
                    self = .cjkEarthlyBranch
                case "cjk-heavenly-stem":
                    self = .cjkHeavenlyStem
                case "japanese-informal":
                    self = .japaneseInformal
                case "japanese-formal":
                    self = .japaneseFormal
                case "korean-hangul-formal":
                    self = .koreanHangulFormal
                case "korean-hanja-informal":
                    self = .koreanHanjaInformal
                case "korean-hanja-formal":
                    self = .koreanHanjaFormal
                case "simp-chinese-informal":
                    self = .simpChineseInformal
                case "simp-chinese-formal":
                    self = .simpChineseFormal
                case "trad-chinese-informal":
                    self = .tradChineseInformal
                case "trad-chinese-formal":
                    self = .tradChineseFormal
                case "ethiopic-numeric":
                    self = .ethiopicNumeric
                default:
                    FIXME("counter-style: \(value) not implemented")
                    self = .disc
                }
            }
        }
    }
}
