//
//  Parser.swift
//  css
//
//  Created by Johan Dahlin on 2024-01-05.
//

import Foundation

// https://www.w3.org/TR/css-syntax-3/#at-rule
public struct AtRule {
    var name: String
    var prelude: [ComponentValue]
    var simpleBlock: SimpleBlock?
}

// https://www.w3.org/TR/css-syntax-3/#qualified-rule
// A qualified rule has a prelude consisting of a list of component values,
// and a block consisting of a simple {} block.

public struct QualifiedRule {
    public var prelude: [ComponentValue]
    public var simpleBlock: SimpleBlock

    func tokens() -> [Token] {
        prelude.compactMap {
            if case let .token(token) = $0 {
                return token
            }
            return nil
        }
    }
}

// https://www.w3.org/TR/css-syntax-3/#declaration
struct Declaration {
    var name: InputToken
    var value: [ComponentValue]
    var importantFlag: ImportantFlag = .unset
}

public enum InputToken {
    case componentValue(ComponentValue)
    case token(Token)
}

// https://www.w3.org/TR/css-syntax-3/#component-value
// A component value is one of the preserved tokens, a function, or a simple block.
public indirect enum ComponentValue: CustomStringConvertible {
    // Any token produced by the tokenizer except for <function-token>s, <{-token>s, <(-token>s, and <[-token>s.
    case token(Token)
    case function(Function)
    case simpleBlock(SimpleBlock)

    public var description: String {
        switch self {
        case let .token(token): "CV(\(token))"
        case let .function(f): "CV(\(f))"
        case let .simpleBlock(simpleBlock): "CV(\(simpleBlock))"
        }
    }

    public func ident() -> String? {
        if case let .token(.ident(ident)) = self {
            return ident
        }
        return nil
    }

    public func token() -> Token? {
        switch self {
        case let .token(
            token): token
        default: nil
        }
    }

    public func isToken(_ token: Token) -> Bool {
        switch self {
        case .token(token): true
        default: false
        }
    }
}

public enum Rule: CustomStringConvertible {
    case at(AtRule)
    case qualified(QualifiedRule)

    public var description: String {
        switch self {
        case let .at(at): "R: \(at)"
        case let .qualified(qualified): "R: \(qualified)"
        }
    }
}

enum Item {
    case atRule(AtRule)
    case qualifiedRule(QualifiedRule)
    case declaration(Declaration)
    case componentValue(ComponentValue)
    case function(Function)
    case simpleBlock(SimpleBlock)
    case inputToken(InputToken)
}

// https://www.w3.org/TR/css-syntax-3/#function
public struct Function {
    var name: String
    var value: [ComponentValue]
}

// https://www.w3.org/TR/css-syntax-3/#simple-block
public struct SimpleBlock: CustomStringConvertible {
    public var token: Token
    public var value: [ComponentValue]

    public var description: String {
        "SB(\(token), \(value)"
    }
}

enum ImportantFlag {
    case unset
    case set
}

enum ToplevelFlag {
    case unset
    case set
}

enum ParserError: Error {
    case eof
    case unexpectedToken
}

public struct ParsedStyleSheet: CustomStringConvertible {
    public var rules: [Rule]
    public var location: URL?

    public var description: String {
        "\(rules)"
    }

    public func qualifiedRuleTokens() -> [Token] {
        var tokens: [Token] = []
        for case let .qualified(qualifiedRule) in self.rules {
            for case let .simpleBlock(block) in qualifiedRule.prelude {
                for case let .token(token) in block.value {
                    tokens.append(token)
                }
            }
        }
        return tokens
    }
}

// 5.3.3 https://www.w3.org/TR/css-syntax-3/#parse-stylesheet
public func parseAStylesheet(_ tokenStream: inout TokenStream, location: URL? = .none) throws -> ParsedStyleSheet {
    // To parse a stylesheet from an input given an optional url location:
    // 1. If input is a byte stream for stylesheet, decode bytes from input, and set input to the result.
    // 2. Normalize input, and set input to the result.
    // 3. Create a new stylesheet, with its location set to location (or null, if location was not passed).

    // 4. Consume a list of rules from input, with the top-level flag set, and set the stylesheet’s value to the result.
    let rules = try consumeListOfRules(&tokenStream, toplevelFlag: .set)

    // 5. Return the stylesheet.
    return ParsedStyleSheet(rules: rules, location: location)
}

public func parseAStylesheet(data: String, location: URL? = .none) throws -> ParsedStyleSheet {
    var tokenStream = CSS.TokenStream(data)
    return try parseAStylesheet(&tokenStream, location: location)
}

public func parseAStylesheet(filename: String, location: URL? = .none) throws -> ParsedStyleSheet {
    let data = try String(contentsOfFile: filename)
    var tokenStream = CSS.TokenStream(data)
    return try parseAStylesheet(&tokenStream, location: location)
}

// 5.4.1 https://www.w3.org/TR/css-syntax-3/#consume-list-of-rules
func consumeListOfRules(_ tokenStream: inout TokenStream,
                        toplevelFlag: ToplevelFlag = ToplevelFlag.unset) throws -> [Rule]
{
    // Create an initially empty list of rules.
    var rules: [Rule] = []

    // Repeatedly consume the next input token:
    repeat {
        switch try tokenStream.consumeNextInputToken() {
        // <whitespace-token>
        case .token(.whitespace):
            // Do nothing.
            continue

        // <EOF-token>
        case .token(.eof):
            // Return the list of rules.
            return rules

        // <CDO-token>
        // <CDC-token>
        case .token(.cdo), .token(.cdc):
            // If the top-level flag is set, do nothing.
            if toplevelFlag == .set { continue }

            // Otherwise, reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // Consume a qualified rule.
            if let qualifiedRule = try consumeQualifiedRule(&tokenStream) {
                // If anything is returned, append it to the list of rules.
                rules.append(Rule.qualified(qualifiedRule))
            }

        // <at-keyword-token>
        case let .token(.atKeyword(name)):
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            //  Consume an at-rule,
            let atRule = try consumeAtRule(&tokenStream, name: name)

            // and append the returned value to the list of rules.
            rules.append(Rule.at(atRule))

        // anything else
        default:
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // Consume a qualified rule.
            if let qualifiedRule = try consumeQualifiedRule(&tokenStream) {
                // If anything is returned, append it to the list of rules.
                rules.append(Rule.qualified(qualifiedRule))
            }
        }

    } while true
}

// 5.4.2 https://www.w3.org/TR/css-syntax-3/#consume-at-rule
func consumeAtRule(_ tokens: inout TokenStream, name: String) throws -> AtRule {
    // Consume the next input token.
    // _ = try parser.consumeNextInputToken()

    // Create a new at-rule with its name set to the value of the current input token
    // its prelude initially set to an empty list, and its value initially set to nothing.
    var prelude: [ComponentValue] = []

    // Repeatedly consume the next input token:
    repeat {
        switch try tokens.consumeNextInputToken() {
        // <semicolon-token>
        case .token(.semicolon):
            return AtRule(name: name, prelude: prelude)

        // <EOF-token>
        case .token(.eof):
            // This is a parse error. Return the at-rule.
            return AtRule(name: name, prelude: prelude)

        // <{-token>
        case .token(.lcurlybracket):
            // Consume a simple block and assign it to the at-rule’s block. Return the at-rule.
            let simpleBlock = try consumeSimpleBlock(&tokens)
            return AtRule(name: name, prelude: prelude, simpleBlock: simpleBlock)

        // simple block with an associated token of <{-token>
        case let .componentValue(.simpleBlock(simpleBlock)):
            // Assign the block to the at-rule’s block. Return the at-rule.
            return AtRule(name: name, prelude: prelude, simpleBlock: simpleBlock)

        // anything else
        default:
            // Reconsume the current input token.
            tokens.reconsumeCurrentInputToken()

            // Consume a component value.
            let componentValue = try consumeComponentValue(&tokens)

            // Append the returned value to the at-rule’s prelude.
            prelude.append(componentValue)
        }
    } while true
}

// 5.4.3 https://www.w3.org/TR/css-syntax-3/#consume-qualified-rule
func consumeQualifiedRule(_ parser: inout TokenStream) throws -> QualifiedRule? {
    // Create a new qualified rule with its prelude initially set to an empty list, and its value initially set to nothing.
    var prelude: [ComponentValue] = []

    // Repeatedly consume the next input token:
    repeat {
        switch try parser.consumeNextInputToken() {
//            // Note: not in spec
//            case .token(.whitespace):
//                continue

        // <EOF-token>
        case .token(.eof):
            // This is a parse error. Return nothing.
            return .none

        // <{-token>
        case .token(.lcurlybracket):
            // Consume a simple block and assign it to the at-rule’s block. Return the at-rule.
            let simpleBlock = try consumeSimpleBlock(&parser)
            return QualifiedRule(prelude: prelude, simpleBlock: simpleBlock)

        // simple block with an associated token of <{-token>
        case let .componentValue(.simpleBlock(simpleBlock)):
            // Assign the block to the qualified rule’s block. Return the qualified rule.
            return QualifiedRule(prelude: prelude, simpleBlock: simpleBlock)

        // anything else
        default:
            // Reconsume the current input token.
            parser.reconsumeCurrentInputToken()

            // Consume a component value.
            let componentValue = try consumeComponentValue(&parser)

            // Append the returned value to the at-rule’s prelude.
            prelude.append(componentValue)
        }
    } while true
}

// 5.4.4 https://www.w3.org/TR/css-syntax-3/#consume-style-block
func consumeStyleBlock(_ tokenStream: inout TokenStream) throws -> [Item] {
    // Create an initially empty list of declarations decls, and an initially empty list of rules rules.
    var decls: [Item] = []
    var rules: [Item] = []

    // Repeatedly consume the next input token:
    repeat {
        switch try tokenStream.consumeNextInputToken() {
        // <whitespace-token>
        // <semicolon-token>
        case .token(.whitespace), .token(.semicolon):
            // Do nothing.
            continue

        // <EOF-token>
        case .token(.eof):
            // Extend decls with rules, then return decls.
            decls.append(contentsOf: rules)
            return decls

        // <at-keyword-token>
        case let .token(.atKeyword(name)):
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            //  Consume an at-rule,
            let atRule = try consumeAtRule(&tokenStream, name: name)

            // and append the returned value to the list of rules.
            rules.append(Item.atRule(atRule))

        // <ident-token>
        case .token(.ident):
            // Initialize a temporary list initially filled with the current input token.
            var temporaryList: [InputToken] = try [tokenStream.currentInputToken()]

            // As long as the next input token is anything other than a <semicolon-token> or <EOF-token>,
            outer: repeat {
                switch try tokenStream.consumeNextInputToken() {
                case .token(.whitespace), .token(.eof):
                    break outer

                default:
                    // Consume a component value.
                    let componentValue = try consumeComponentValue(&tokenStream)

                    // append it to the temporary list
                    temporaryList.append(InputToken.componentValue(componentValue))
                }
            } while true

            // Consume a declaration from the temporary list.
            var tokenStream = TokenStream(inputTokens: temporaryList)

            if let decl = try consumeDeclaration(&tokenStream) {
                // If anything was returned, append it to decls.
                decls.append(Item.declaration(decl))
            }

        // <delim-token> with a value of "&" (U+0026 AMPERSAND)
        case let .token(.delim(value)) where value == "&":

            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // Consume a qualified rule.
            if let qualifiedRule = try consumeQualifiedRule(&tokenStream) {
                // If anything was returned, append it to rules.
                rules.append(Item.qualifiedRule(qualifiedRule))
            }

        // anything else
        default:
            // This is a parse error.

            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // As long as the next input token is anything other than a <semicolon-token> or <EOF-token>,
            repeat {
                switch try tokenStream.consumeNextInputToken() {
                case .token(.whitespace), .token(.eof):
                    break

                default:
                    // consume a component value and throw away the returned value.
                    _ = try consumeComponentValue(&tokenStream)
                }
            } while true
        }

    } while true
}

// 5.4.5 https://www.w3.org/TR/css-syntax-3/#consume-list-of-declarations
func consumeListOfDeclarations(_ tokenStream: inout TokenStream) throws -> [Item] {
    // Create an initially empty list of declarations.
    var declarations: [Item] = []

    repeat {
        switch try tokenStream.consumeNextInputToken() {
        // <whitespace-token>
        // <semicolon-token>
        case .token(.whitespace), .token(.semicolon):
            // Do nothing.
            continue

        // <EOF-token>
        case .token(.eof):
            // Return the list of declarations.
            return declarations

        // <at-keyword-token>
        case let .token(.atKeyword(name)):
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            //  Consume an at-rule,
            let atRule = try consumeAtRule(&tokenStream, name: name)

            // and append the returned value to the list of rules.
            declarations.append(Item.atRule(atRule))

        // <ident-token>
        case .token(.ident):
            // Initialize a temporary list initially filled with the current input token.
            var temporaryList: [InputToken] = try [tokenStream.currentInputToken()]

            // As long as the next input token is anything other than a <semicolon-token> or <EOF-token>,
            outer: repeat {
                switch try tokenStream.consumeNextInputToken() {
                case .token(.whitespace), .token(.eof):
                    break outer

                default:
                    // Consume a component value.
                    let componentValue = try consumeComponentValue(&tokenStream)

                    // append it to the temporary list
                    temporaryList.append(InputToken.componentValue(componentValue))
                }
            } while true

            // Consume a declaration from the temporary list.
            var tokenStream = TokenStream(inputTokens: temporaryList)

            if let decl = try consumeDeclaration(&tokenStream) {
                // If anything was returned, append it to decls.
                declarations.append(Item.declaration(decl))
            }

        // anything else
        default:
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // As long as the next input token is anything other than a <semicolon-token> or <EOF-token>,
            repeat {
                switch try tokenStream.consumeNextInputToken() {
                case .token(.whitespace), .token(.eof):
                    break

                default:
                    // consume a component value and throw away the returned value.
                    _ = try consumeComponentValue(&tokenStream)
                }
            } while true
        }
    } while true
}

// 5.4.6 https://www.w3.org/TR/css-syntax-3/#consume-declaration
func consumeDeclaration(_ tokenStream: inout TokenStream) throws -> Declaration? {
    // Note: This algorithm assumes that the next input token has already been checked to be an <ident-token>.

    // Consume the next input token. Create a new declaration with its name set to the value of
    // the current input token and its value initially set to an empty list.
    var value: [ComponentValue] = []

    let name = try tokenStream.consumeNextInputToken()

    // 1. While the next input token is a <whitespace-token>, consume the next input token.
    try tokenStream.consumeWhile(Token.whitespace)

    // 2. If the next input token is anything other than a <colon-token>
    guard case .token(.colon) = try tokenStream.consumeNextInputToken() else {
        // this is a parse error.
        // Return nothing.
        return nil
    }

    // 3. While the next input token is a <whitespace-token>, consume the next input token.
    try tokenStream.consumeWhile(Token.whitespace)

    // 4. As long as the next input token is anything other than an <EOF-token>,
    // consume a component value and append it to the declaration’s value.
    repeat {
        if case .token(.eof) = try tokenStream.consumeNextInputToken() {
            break
        }

        // consume a component value and
        let componentValue = try consumeComponentValue(&tokenStream)

        // append it to the declaration’s value.
        value.append(componentValue)
    } while true

    // FIXME: 5. If the last two non-<whitespace-token>s in the declaration’s value are a <delim-token> with the value "!" followed by an <ident-token> with a value that is an ASCII case-insensitive match for "important", remove them from the declaration’s value and set the declaration’s important flag to true.

    // FIXME: 6. While the last token in the declaration’s value is a <whitespace-token>, remove that token.

    // 7. Return the declaration
    return Declaration(name: name, value: value)
}

// 5.4.7 https://www.w3.org/TR/css-syntax-3/#consume-component-value
func consumeComponentValue(_ tokenStream: inout TokenStream) throws -> ComponentValue {
    // Consume the next input token.
    switch try tokenStream.consumeNextInputToken() {
    // If the current input token is a <{-token>, <[-token>, or <(-token>,
    case .token(.lcurlybracket), .token(.lbracket), .token(.lparan):
        // consume a simple block and return it.
        try ComponentValue.simpleBlock(consumeSimpleBlock(&tokenStream))

    // Otherwise, if the current input token is a <function-token>
    case let .token(.function(name)):
        // consume a function and return it.
        try ComponentValue.function(consumeFunction(&tokenStream, name: name))

    // Otherwise
    case let inputToken:
        // return the current input token.
        switch inputToken {
        case let .componentValue(componentValue): componentValue
        case let .token(token): ComponentValue.token(token)
        }
    }
}

// 5.4.8 https://www.w3.org/TR/css-syntax-3/#consume-a-simple-block
func consumeSimpleBlock(_ tokenStream: inout TokenStream) throws -> SimpleBlock {
    // The ending token is the mirror variant of the current input token.
    // (E.g. if it was called with <[-token>, the ending token is <]-token>.)
    let endingToken: Token = switch try tokenStream.currentInputToken() {
    case .token(.lparan): .rparan
    case .token(.lbracket): .rbracket
    case .token(.lcurlybracket): .rcurlybracket
    default:
        throw ParserError.unexpectedToken
    }

    // Create a simple block with its associated token set to the current input token and
    // with its value initially set to an empty list.
    var value: [ComponentValue] = []

    // Repeatedly consume the next input token and process it as follows:
    repeat {
        switch try tokenStream.consumeNextInputToken() {
        // ending token
        case let .token(token) where token == endingToken:
            // Return the block.
            return SimpleBlock(token: token, value: value)

        // <EOF-token>
        case .token(.eof):
            // This is a parse error. Return the block.
            return SimpleBlock(token: endingToken, value: value)

        // anything else
        default:
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // Consume a component value.
            let componentValue = try consumeComponentValue(&tokenStream)

            // append it to the value of the block.
            value.append(componentValue)
        }
    } while true
}

// 5.4.9 https://www.w3.org/TR/css-syntax-3/#consume-function
func consumeFunction(_ tokenStream: inout TokenStream, name: String) throws -> Function {
    // Create a function with its name equal to the value of the current input token and
    // with its value initially set to an empty list.
    var value: [ComponentValue] = []

    // Repeatedly consume the next input token and process it as follows:
    repeat {
        switch try tokenStream.consumeNextInputToken() {
        // <)-token>
        case .token(.rparan):
            // Return the function.
            return Function(name: name, value: value)

        // <EOF-token>
        case .token(.eof):
            // This is a parse error. Return the function.
            return Function(name: name, value: value)

        default:
            // Reconsume the current input token.
            tokenStream.reconsumeCurrentInputToken()

            // Consume a component value.
            let componentValue = try consumeComponentValue(&tokenStream)

            // append it to the value of the block.
            value.append(componentValue)
        }
    } while true
}
