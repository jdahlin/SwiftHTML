typealias Codepoint = Unicode.Scalar

extension Codepoint {
    var isSign: Bool {
        self == "-" || self == "+"
    }

    // https://www.w3.org/TR/css-syntax-3/#digit
    var isDigit: Bool {
        // A code point between U+0030 DIGIT ZERO (0) and U+0039 DIGIT NINE (9) inclusive.
        "0" ... "9" ~= self
    }

    // https://www.w3.org/TR/css-syntax-3/#hex-digit
    var isHexDigit: Bool {
        // A digit,
        isDigit
            // or a code point between U+0041 LATIN CAPITAL LETTER A (A) and
            // U+0046 LATIN CAPITAL LETTER F (F) inclusive,
            || "A" ... "F" ~= self
            // or a code point between U+0061 LATIN SMALL LETTER A (a) and
            // U+0066 LATIN SMALL LETTER F (f) inclusive.
            || "a" ... "f" ~= self
    }

    // https://www.w3.org/TR/css-syntax-3/#whitespace
    var isWhitespace: Bool {
        // A newline, U+0009 CHARACTER TABULATION, or U+0020 SPACE.
        self == "\n" || self == "\t" || self == " "
    }

    // https://www.w3.org/TR/css-syntax-3/#letter
    var isLetter: Bool {
        // An uppercase letter
        "A" ... "Z" ~= self
            // or a lowercase letter.
            || "a" ... "z" ~= self
    }

    // https://www.w3.org/TR/css-syntax-3/#non-ascii-code-point
    var isNonASCIICodePoint: Bool {
        // A code point with a value equal to or greater than U+0080 <control>.
        self >= Codepoint(0x0080)
    }

    // https://www.w3.org/TR/css-syntax-3/#ident-start-code-point
    var isIdentStartCodePoint: Bool {
        // A letter,
        isLetter
            // a non-ASCII code point,
            || isNonASCIICodePoint
            // or U+005F LOW LINE (_).
            || self == "_"
    }

    // https://www.w3.org/TR/css-syntax-3/#ident-code-point
    func isIdentCodePoint() -> Bool {
        // An ident-start code point,
        isIdentStartCodePoint
            // a digit,
            || isDigit
            // or U+002D HYPHEN-MINUS (-).
            || self == "-"
    }

    // https://www.w3.org/TR/css-syntax-3/#maximum-allowed-code-point
    static var maximumAllowedCodePoint: UInt32 {
        // The greatest code point defined by Unicode: U+10FFFF.
        UInt32(0x10FFFF)
    }

    // https://en.wikipedia.org/wiki/Specials_(Unicode_block)#Replacement_character
    static var replacementCharacter: Codepoint {
        Codepoint(UInt32(0xFFFD))!
    }
}

extension CSS {
    enum NumericType {
        case number
        case integer
    }

    enum Number: Equatable, CustomStringConvertible {
        case Integer(Int64)
        case Number(Double)

        var description: String {
            switch self {
            case let .Integer(i):
                "\(i)"
            case let .Number(n):
                "\(n)"
            }
        }
    }

    enum HashFlag: Equatable {
        case id
        case unrestricted
    }

    // https://www.w3.org/TR/css-syntax-3/#tokenization
    enum Token: Equatable {
        case ident(String)
        case function(String)
        case atKeyword(keyword: String)
        case hashToken(hash: String, flag: HashFlag = .unrestricted)
        case string(String)
        case badString
        case url(String)
        case badUrl
        case delim(Codepoint)
        case number(number: Number)
        case percentage(number: Number)
        case dimension(number: Number, unit: String)
        case whitespace
        case cdo
        case cdc
        case colon
        case semicolon
        case comma
        case lbracket
        case rbracket
        case lparan
        case rparan
        case lcurlybracket
        case rcurlybracket
        case eof
    }

    enum TokenizerError: Error {
        case invalid(String)
        case parseError
        case unknown
        case eof
    }

    struct Tokenizer: Sequence {
        var stream: String.UnicodeScalarView
        var pos: String.Index

        init(_ string: String) {
            stream = string.unicodeScalars
            pos = stream.startIndex
        }

        @discardableResult mutating func consume() throws -> Codepoint {
            if let c = peek() {
                pos = stream.index(pos, offsetBy: 1)
                return c
            } else {
                throw TokenizerError.eof
            }
        }

        @discardableResult mutating func consumeMany(_ offsetBy: Int) throws -> String {
            var s = ""
            for _ in 0 ..< offsetBy {
                let codePoint = try self.consume()
                s.append(String(UnicodeScalar(codePoint)))
            }
            return s
        }

        func peek(_ nth: Int = 0) -> Codepoint? {
            let pos = stream.index(pos, offsetBy: nth, limitedBy: stream.endIndex)
            if let pos, pos != stream.endIndex {
                return .some(stream[pos])
            } else {
                return .none
            }
        }

        func peekOrThrow(_ nth: Int = 0) throws -> Codepoint {
            if let c = peek(nth) {
                return c
            } else {
                throw TokenizerError.eof
            }
        }

        func peekMany(_ offsetBy: Int = 2) -> String? {
            let end = stream.index(pos, offsetBy: offsetBy - 1, limitedBy: stream.endIndex)
            if let end, end != stream.endIndex {
                return Optional.some(String(stream[pos ... end]))
            } else {
                return Optional.none
            }
        }

        mutating func matches(_ expected: String) throws -> Bool {
            let matches = peekMany(expected.count)
            switch matches {
            case .none: throw TokenizerError.eof
            case let .some(match) where match == expected:
                try self.consume()
                return true
            case .some:
                return false
            }
        }

        func makeIterator() -> some IteratorProtocol {
            TokenizerTokenIterator(self)
        }
    }

    struct TokenizerTokenIterator: IteratorProtocol {
        var tokenizer: Tokenizer
        var eof = false

        init(_ tokenizer: Tokenizer) {
            self.tokenizer = tokenizer
        }

        mutating func next() -> Token? {
            do {
                return try consumeToken(&tokenizer)
            } catch TokenizerError.eof {
                if eof {
                    return nil
                } else {
                    eof = true
                    return Token.eof
                }
            } catch {
                fatalError("\(error)")
            }
        }
    }

    enum HashOrDelim {
        case hash
        case delim
    }

    // 4.3.1 https://www.w3.org/TR/css-syntax-3/#consume-token
    static func consumeToken(_ tokenizer: inout Tokenizer) throws -> Token {
        try consumeComments(&tokenizer)

        switch try tokenizer.peekOrThrow() {
        // whitespace
        case let c where c.isWhitespace:
            // Consume as much whitespace as possible. Return a <whitespace-token>.
            while try tokenizer.peekOrThrow().isWhitespace {
                try tokenizer.consume()
            }
            return Token.whitespace

        // U+0022 QUOTATION MARK (")
        case "\"":
            let endingCodePoint = try tokenizer.consume()
            return try consumeStringToken(&tokenizer, endingCodePoint: endingCodePoint)

        // U+0023 NUMBER SIGN (#)
        case "#":
            _ = try tokenizer.consume()
            // FIXME: If the next input code point is an ident code point or the next two input code points are a valid escape, then:
            // 1. Create a <hash-token>.
            // 2. If the next 3 input code points would start an ident sequence, set the <hash-token>’s type flag to "id".
            // 3. Consume an ident sequence, and set the <hash-token>’s value to the returned string.
            let hash = try consumeIdentSequence(&tokenizer)
            // 4. Return the <hash-token>.
            // FIXME: return a <delim-token> with its value set to the current input code point.
            return Token.hashToken(hash: hash, flag: HashFlag.id)

        // U+0027 APOSTROPHE (')
        case "'":
            let endingCodePoint = try tokenizer.consume()
            return try consumeStringToken(&tokenizer, endingCodePoint: endingCodePoint)

        // U+0028 LEFT PARENTHESIS (()
        case "(":
            try tokenizer.consume()
            // Return a <(-token>.
            return Token.lparan

        // U+0029 RIGHT PARENTHESIS ())
        case ")":
            try tokenizer.consume()
            // Return a <)-token>.
            return Token.rparan

        // U+002B PLUS SIGN (+)
        case "+":
            // If the input stream starts with a number, reconsume the current input code point, consume a numeric token, and return it.
            if try checkIfThreeCodePointsWouldStartANumber(
                c1: tokenizer.peekOrThrow(0),
                c2: tokenizer.peekOrThrow(1),
                c3: tokenizer.peekOrThrow(2)
            ) {
                _ = try tokenizer.consume()
                return try Token.number(number: consumeNumber(&tokenizer))
            } else {
                // Otherwise, return a <delim-token> with its value set to the current input code point.
                let c = try tokenizer.consume()
                return Token.delim(c)
            }

        // U+002C COMMA (,)
        case ",":
            try tokenizer.consume()
            // Return a <comma-token>.
            return Token.comma

        // U+002D HYPHEN-MINUS (-)
        case "-":
            if try checkIfThreeCodePointsWouldStartANumber(
                c1: tokenizer.peekOrThrow(0),
                c2: tokenizer.peekOrThrow(1),
                c3: tokenizer.peekOrThrow(2)
            ) {
                // If the input stream starts with a number, reconsume the current input code point, consume a numeric token, and return it.
                _ = try tokenizer.consume()
                return try Token.number(number: consumeNumber(&tokenizer))
                // FIXME: Otherwise, if the next 2 input code points are U+002D HYPHEN-MINUS U+003E GREATER-THAN SIGN (->), consume them and return a <CDC-token>.
                // Otherwise, if the input stream starts with an ident sequence, reconsume the current input code point, consume an ident-like token, and return it.
            } else if try checkIfThreeCodePointsWouldStartIdentSequence(
                c1: tokenizer.peekOrThrow(0),
                c2: tokenizer.peekOrThrow(1),
                c3: tokenizer.peekOrThrow(2)
            ) {
                _ = try tokenizer.consume()
                return try Token.ident(consumeIdentSequence(&tokenizer))
            } else {
                let c = try tokenizer.consume()
                return Token.delim(c)
            }

        // U+002E FULL STOP (.)
        case ".":
            // If the input stream starts with a number, reconsume the current input code point, consume a numeric token, and return it.
            if try checkIfThreeCodePointsWouldStartANumber(
                c1: tokenizer.peekOrThrow(0),
                c2: tokenizer.peekOrThrow(1),
                c3: tokenizer.peekOrThrow(2)
            ) {
                _ = try tokenizer.consume()
                return try Token.number(number: consumeNumber(&tokenizer))
            } else {
                // Otherwise, return a <delim-token> with its value set to the current input code point.
                let c = try tokenizer.consume()
                return Token.delim(c)
            }
        // U+003A COLON (:)
        case ":":
            try tokenizer.consume()
            // Return a <colon-token>.
            return Token.colon

        // U+003B SEMICOLON (;)
        case ";":
            try tokenizer.consume()
            // Return a <semicolon-token>.
            return Token.semicolon

        // U+003C LESS-THAN SIGN (<)
        case "<":
            let c = try tokenizer.consume()
            // FIXME: If the next 3 input code points are U+0021 EXCLAMATION MARK U+002D HYPHEN-MINUS U+002D HYPHEN-MINUS (!--), consume them and return a <CDO-token>.
            // Otherwise, return a <delim-token> with its value set to the current input code point.
            return Token.delim(c)

        // U+0040 COMMERCIAL AT (@)
        case "@":
            // If the next 3 input code points would start an ident sequence, consume an ident sequence, create an <at-keyword-token> with its value set to the returned value, and return it.
            if try checkIfThreeCodePointsWouldStartIdentSequence(
                c1: tokenizer.peekOrThrow(0),
                c2: tokenizer.peekOrThrow(1),
                c3: tokenizer.peekOrThrow(2)
            ) {
                return try Token.atKeyword(keyword: consumeIdentSequence(&tokenizer))
            }
            // Otherwise, return a <delim-token> with its value set to the current input code point.
            let c = try tokenizer.consume()
            return Token.delim(c)

        // U+005B LEFT SQUARE BRACKET ([)
        case "[":
            try tokenizer.consume()
            // Return a <[-token>.
            return Token.lbracket

        // U+005C REVERSE SOLIDUS (\)
        case "\\":
            try tokenizer.consume()
            // FIXME: If the input stream starts with a valid escape, reconsume the current input code point, consume an ident-like token, and return it.
            // FIXME: Otherwise, this is a parse error. Return a <delim-token> with its value set to the current input code point.
            return Token.string("FIXME: \\")

        // U+005D RIGHT SQUARE BRACKET (])
        case "]":
            try tokenizer.consume()
            // Return a <]-token>.
            return Token.rbracket

        // U+007B LEFT CURLY BRACKET ({)
        case "{":
            try tokenizer.consume()
            // Return a <{-token>.
            return Token.lcurlybracket

        // U+007D RIGHT CURLY BRACKET (})
        case "}":
            try tokenizer.consume()
            // Return a <}-token>.
            return Token.rcurlybracket

        // digit
        case let c where c.isDigit:
            // Reconsume the current input code point, consume a numeric token, and return it.
            return try consumeNumeric(&tokenizer)

        // ident-start code point
        case let c where c.isIdentStartCodePoint:
            // Reconsume the current input code point, consume an ident-like token, and return it.
            return try consumeIdentLikeToken(&tokenizer)

        // anything else
        case _:
            // Return a <delim-token> with its value set to the current input code point.
            return try Token.delim(tokenizer.consume())
        }
    }

    // 4.3.2 https://www.w3.org/TR/css-syntax-3/#consume-comment
    static func consumeComments(_ tokenizer: inout Tokenizer) throws {
        // If the next two input code point are U+002F SOLIDUS (/) followed by a U+002A ASTERISK (*),
        if try tokenizer.matches("/*") {
            // consume them and all following code points up to and including the first U+002A ASTERISK (*)
            // followed by a U+002F SOLIDUS (/), or up to an EOF code point.
            while tokenizer.peekMany(2) != .some("*/") {
                try tokenizer.consume()
                // Return to the start of this step.
            }

            // FIXME: If the preceding paragraph ended by consuming an EOF code point, this is a parse error.
        }

        // Return nothing.
    }

    // 4.3.3 https://www.w3.org/TR/css-syntax-3/#consume-numeric-token
    static func consumeNumeric(_ tokenizer: inout Tokenizer) throws -> Token {
        // Consume a number and let number be the result.
        let number = try consumeNumber(&tokenizer)

        // If the next 3 input code points would start an ident sequence, then:
        if try checkIfThreeCodePointsWouldStartIdentSequence(
            c1: tokenizer.peekOrThrow(0),
            c2: tokenizer.peekOrThrow(1),
            c3: tokenizer.peekOrThrow(2)
        ) {
            // Create a <dimension-token> with the same value and type flag as number, and a unit set initially to the empty string.

            // Consume an ident sequence. Set the <dimension-token>’s unit to the returned value.
            let unit = try consumeIdentSequence(&tokenizer)

            // Return the <dimension-token>.
            return Token.dimension(number: number, unit: unit)

            // Otherwise, if the next input code point is U+0025 PERCENTAGE SIGN (%), consume it. Create a <percentage-token> with the same value as number, and return it.
        } else if let c = tokenizer.peek(), c == "%" {
            try tokenizer.consume()
            return Token.percentage(number: number)
        }

        // Otherwise, create a <number-token> with the same value and type flag as number, and return it.
        return Token.number(number: number)
    }

    // 4.3.4 https://www.w3.org/TR/css-syntax-3/#consume-ident-like-token
    static func consumeIdentLikeToken(_ tokenizer: inout Tokenizer) throws -> Token {
        // Consume an ident sequence, and let string be the result.
        let string = try consumeIdentSequence(&tokenizer)

        // If string’s value is an ASCII case-insensitive match for "url",
        // and the next input code point is U+0028 LEFT PARENTHESIS ((),
        // consume it. While the next two input code points are whitespace,
        // consume the next input code point.
        if string.lowercased() == "url" {
            if let nextChar = tokenizer.peek(), nextChar == "(" {
                try tokenizer.consume()

                while let nextTwoChars = tokenizer.peekMany(2), nextTwoChars.allSatisfy(\.isWhitespace) {
                    try tokenizer.consume()
                }

                // If the next one or two input code points are U+0022 QUOTATION MARK ("),
                // U+0027 APOSTROPHE ('), or whitespace followed by U+0022 QUOTATION MARK (") or
                // U+0027 APOSTROPHE ('), then create a <function-token> with its value
                // set to string and return it. Otherwise, consume a url token, and return it.
                if let nextChar = tokenizer.peek(), nextChar == "\"" || nextChar == "'" {
                    return Token.function(string)
                } else {
                    return try consumeURLToken(&tokenizer)
                }
            }
        }

        // Otherwise, if the next input code point is U+0028 LEFT PARENTHESIS ((), consume it.
        // Create a <function-token> with its value set to string and return it.
        if let nextChar = tokenizer.peek(), nextChar == "(" {
            try tokenizer.consume()
            return Token.function(string)
        }

        // Otherwise, create an <ident-token> with its value set to string and return it.
        return Token.ident(string)
    }

    // 4.3.5 https://www.w3.org/TR/css-syntax-3/#consume-string-token
    static func consumeStringToken(_ tokenizer: inout Tokenizer, endingCodePoint: Codepoint? = nil) throws -> Token {
        // Initially create a <string-token> with its value set to the empty string.
        var string = ""
        // Repeatedly consume the next input code point from the stream:
        while true {
            switch tokenizer.peek() {
            // ending code point, Return the <string-token>.
            case endingCodePoint:
                try tokenizer.consume()
                return Token.string(string)

            // EOF, This is a parse error. Return the <string-token>.
            case .none:
                return Token.string(string)

            // newline, This is a parse error. Reconsume the current input code point, create a <bad-string-token>, and return it.
            case "\n":
                return Token.badString

            // U+005C REVERSE SOLIDUS (\)
            case "\\":
                try tokenizer.consume()
                switch tokenizer.peek() {
                // If the next input code point is EOF, do nothing.
                case nil:
                    break
                // Otherwise, if the next input code point is a newline, consume it.
                case "\n":
                    try tokenizer.consume()
                // Otherwise, (the stream starts with a valid escape) consume an escaped code point and append the returned code point to the <string-token>’s value.
                default:
                    if let nextChar = tokenizer.peek(), checkIfTwoCodePointsAreAValidEscape(c1: "\\", c2: nextChar) {
                        try string.append(Character(consumeEscapedCodePoint(&tokenizer)))
                    }
                }

            // anything else, Append the current input code point to the <string-token>’s value.
            default:
                try string.append(Character(tokenizer.peekOrThrow()))
                try tokenizer.consume()
            }
        }
    }

    // 4.3.6 https://www.w3.org/TR/css-syntax-3/#consume-url-token
    static func consumeURLToken(_ tokenizer: inout Tokenizer) throws -> Token {
        // Initially create a <url-token> with its value set to the empty string.
        var url = ""

        // Consume as much whitespace as possible.
        while let nextChar = tokenizer.peek(), nextChar.isWhitespace {
            try tokenizer.consume()
        }

        // Repeatedly consume the next input code point from the stream:
        repeat {
            switch try tokenizer.peekOrThrow() {
            // U+0029 RIGHT PARENTHESIS ()) or EOF, Return the <url-token>.
            case ")":
                try tokenizer.consume()
                return Token.url(url)

            // whitespace
            case let c where c.isWhitespace:
                while let nextChar = tokenizer.peek(), nextChar.isWhitespace {
                    try tokenizer.consume()
                }
                if let nextChar = tokenizer.peek(), nextChar == ")" {
                    try tokenizer.consume()
                    return Token.url(url)
                } else {
                    try consumeBadURLRemnants(&tokenizer)
                    return Token.badUrl
                }

            // U+0022 QUOTATION MARK ("), U+0027 APOSTROPHE ('), U+0028 LEFT PARENTHESIS ((),
            case "\"", "'", "(":
                try consumeBadURLRemnants(&tokenizer)
                return Token.badUrl

            // non-printable code point
            case let c where !c.isASCII:
                try consumeBadURLRemnants(&tokenizer)
                return Token.badUrl

            // U+005C REVERSE SOLIDUS (\)
            case "\\":
                if checkIfTwoCodePointsAreAValidEscape(&tokenizer) {
                    try url.append(Character(consumeEscapedCodePoint(&tokenizer)))
                } else {
                    try consumeBadURLRemnants(&tokenizer)
                    return Token.badUrl
                }
            // anything else
            case let c:
                // Append the current input code point to the <url-token>’s value.
                url.append(Character(c))
                try tokenizer.consume()
            }
        } while true
    }

    // 4.3.7 https://www.w3.org/TR/css-syntax-3/#consume-escaped-code-point
    static func consumeEscapedCodePoint(_ tokenizer: inout Tokenizer) throws -> Codepoint {
        // Consume the next input code point.
        do {
            try tokenizer.consume()
        } catch TokenizerError.eof {
            // This is a parse error. Return U+FFFD REPLACEMENT CHARACTER (�).
            return "�"
        } catch {
            throw TokenizerError.unknown
        }

        switch tokenizer.peek() {
        // hex digit
        case let .some(c) where c.isHexDigit:
            // Consume as many hex digits as possible, but no more than 5.
            var value = String(c)
            for _ in 0 ..< 5 {
                //  If the next input code point is whitespace, consume it as well
                if let n = tokenizer.peek(), n.isHexDigit || n.isWhitespace {
                    try value.append(String(tokenizer.consume()))
                } else {
                    break
                }
            }

            // Interpret the hex digits as a hexadecimal number.
            let hexValue = UInt32(value, radix: 16)!

            // If this number is zero, or is for a surrogate, or is greater than the maximum allowed code point
            if hexValue == 0
                // FIXME: Surrogate
                || hexValue > Codepoint.maximumAllowedCodePoint
            {
                // return U+FFFD REPLACEMENT CHARACTER (�)
                return Codepoint.replacementCharacter
            } else if let codepoint = Codepoint(hexValue) {
                // Otherwise, return the code point with that value.
                return codepoint
            } else {
                // Handle the case when Codepoint initialization fails
                fatalError("Invalid code point")
            }
        // EOF
        case .none:
            throw TokenizerError.eof
        // anything else
        case let .some(c):
            return c
        }
    }

    // 4.3.8 https://www.w3.org/TR/css-syntax-3/#starts-with-a-valid-escape
    static func checkIfTwoCodePointsAreAValidEscape(_ tokenizer: inout Tokenizer) -> Bool {
        // If the first code point is not U+005C REVERSE SOLIDUS (\), return false.
        guard let c1 = tokenizer.peek() else { return false }

        // Otherwise, if the second code point is a newline, return false.
        guard let c2 = tokenizer.peek() else { return false }

        return checkIfTwoCodePointsAreAValidEscape(c1: c1, c2: c2)
    }

    static func checkIfTwoCodePointsAreAValidEscape(c1: Codepoint, c2: Codepoint) -> Bool {
        // If the first code point is not U+005C REVERSE SOLIDUS (\), return false.
        if c1 != "\\" {
            return false
        }

        // Otherwise, if the second code point is a newline, return false.
        if c2 == "\n" {
            return false
        }

        return true
    }

    // 4.3.9 https://www.w3.org/TR/css-syntax-3/#would-start-an-identifier
    static func checkIfThreeCodePointsWouldStartIdentSequence(c1: Codepoint, c2: Codepoint, c3: Codepoint) -> Bool {
        switch c1 {
        // U+002D HYPHEN-MINUS
        case "-":
            switch c2 {
            // If the second code point is an ident-start code point
            case _ where c2.isIdentStartCodePoint: true
            // or a U+002D HYPHEN-MINUS
            case "-": true
            // or the second and third code points are a valid escape,
            // return true
            case _ where checkIfTwoCodePointsAreAValidEscape(c1: c2, c2: c3): true
            default: false
            }
        // ident-start code point
        case _ where c1.isIdentStartCodePoint:
            // Return true.
            true
        // U+005C REVERSE SOLIDUS (\)
        case "\\":
            // If the first and second code points are a valid escape, return true. Otherwise, return false.
            checkIfTwoCodePointsAreAValidEscape(c1: c1, c2: c2)
        // anything else
        default:
            // Return false.
            false
        }
    }

    // 4.3.10 https://www.w3.org/TR/css-syntax-3/#starts-with-a-number
    static func checkIfThreeCodePointsWouldStartANumber(c1: Codepoint, c2: Codepoint, c3: Codepoint) -> Bool {
        switch c1 {
        // U+002B PLUS SIGN (+)
        // U+002D HYPHEN-MINUS
        case "+", "-":
            // If the second code point is a digit, return true.
            if c2.isDigit {
                true
                // Otherwise, if the second code point is a U+002E FULL STOP (.) and the third code point is a digit, return true.
            } else if c2 == ".", c3.isDigit {
                true
                // Otherwise, return false.
            } else {
                false
            }

        // U+002E FULL STOP (.)
        case ".":
            // If the second code point is a digit, return true.
            if c2.isDigit {
                true
                // Otherwise, return false.
            } else {
                false
            }

        // digit
        case _ where c1.isDigit:
            // Return true.
            true

        // anything else
        default:
            false
        }
    }

    // 4.3.11 https://www.w3.org/TR/css-syntax-3/#consume-name
    static func consumeIdentSequence(_ tokenizer: inout Tokenizer) throws -> String {
        // Let result initially be an empty string.
        var result = ""
        // Repeatedly consume the next input code point from the stream:
        while true {
            let codePoint = try tokenizer.peekOrThrow()
            switch codePoint {
            // ident code point
            case _ where codePoint.isIdentCodePoint():
                // Append the code point to result.
                try result.append(String(tokenizer.consume()))
            // the stream starts with a valid escape
            case _ where checkIfTwoCodePointsAreAValidEscape(&tokenizer):
                // Consume an escaped code point. Append the returned code point to result.
                try result.append(String(consumeEscapedCodePoint(&tokenizer)))
            // anything else
            default:
                // Reconsume the current input code point. Return result.
                return result
            }
        }
    }

    // 4.3.12 https://www.w3.org/TR/css-syntax-3/#consume-a-number
    static func consumeNumber(_ tokenizer: inout Tokenizer) throws -> Number {
        // 1. Initially set type to "integer". Let repr be the empty string.
        var type: NumericType = .integer
        var repr = ""

        // 2. If the next input code point is U+002B PLUS SIGN (+) or U+002D HYPHEN-MINUS (-), consume it and append it to repr.
        let c = try tokenizer.peekOrThrow()
        if c.isSign {
            try repr.append(String(tokenizer.consume()))
        }

        // 3. While the next input code point is a digit, consume it and append it to repr.
        while try tokenizer.peekOrThrow().isDigit {
            try repr.append(String(tokenizer.consume()))
        }

        // 4. If the next 2 input code points are U+002E FULL STOP (.) followed by a digit, then:
        if try tokenizer.peekOrThrow() == "." && tokenizer.peekOrThrow(1).isDigit {
            // 4.1 Consume them
            let dotAndDigit = try tokenizer.consumeMany(2)

            // 4.2 Append them to repr.
            repr.append(dotAndDigit)

            // 4.3 Set type to "number".
            type = .number

            // 4.4 While the next input code point is a digit, consume it and append it to repr.
            while try tokenizer.peekOrThrow().isDigit {
                try repr.append(String(tokenizer.consume()))
            }
        }

        // 5 If the next 2 or 3 input code points are
        // - U+0045 LATIN CAPITAL LETTER E (E) or U+0065 LATIN SMALL LETTER E (e),
        // - optionally followed by U+002D HYPHEN-MINUS (-) or U+002B PLUS SIGN (+),
        // - followed by a digit, then:
        let n = try tokenizer.peekOrThrow(), n2 = try tokenizer.peekOrThrow()
        if try (n == "e" || n == "E") && n2.isDigit || (n2.isSign && tokenizer.peekOrThrow().isDigit) {
            // 5.1 Consume them
            let eSignAndDigit = try tokenizer.consumeMany(3)

            // 5.2 Append them to repr.
            repr.append(eSignAndDigit)

            // 5.3 Set type to "number".
            type = .number

            // 5.4 While the next input code point is a digit, consume it and append it to repr.
            while try tokenizer.peekOrThrow().isDigit {
                try repr.append(String(tokenizer.consume()))
            }
        }

        // 6. Convert repr to a number, and set the value to the returned value.
        switch type {
        case .integer:
            guard let value = Int64(repr) else {
                throw TokenizerError.parseError
            }
            return Number.Integer(value)
        case .number:
            guard let value = Double(repr) else {
                throw TokenizerError.parseError
            }
            return Number.Number(value)
        }
    }

    // 4.3.13 https://www.w3.org/TR/css-syntax-3/#convert-string-to-number

    // 4.3.14 https://www.w3.org/TR/css-syntax-3/#consume-remnants-of-bad-url
    static func consumeBadURLRemnants(_ tokenizer: inout Tokenizer) throws {
        // Repeatedly consume the next input code point from the stream:
        repeat {
            switch tokenizer.peek() {
            // U+0029 RIGHT PARENTHESIS ()) or EOF, Return.
            case ")":
                return
            // the input stream starts with a valid escape
            default:
                if checkIfTwoCodePointsAreAValidEscape(&tokenizer) {
                    _ = try consumeEscapedCodePoint(&tokenizer)
                } else {
                    try tokenizer.consume()
                    // anything else, Do nothing.
                }
            }
        } while true
    }

    static func tokenize(_ tokenizer: inout Tokenizer) throws -> [Token] {
        var tokens: [Token] = []
        for _ in 0 ..< 1000 { // Limit to 1000 tokens to prevent infinite loops
            let token = try consumeToken(&tokenizer)
            if token == .eof {
                break
            }
            tokens.append(token)
        }
        return tokens
    }
}
