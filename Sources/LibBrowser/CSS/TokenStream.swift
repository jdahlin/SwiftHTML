//
//  TokenStream.swift
//  CSS
//
//  Created by Johan Dahlin on 2024-01-08.
//

import Foundation

extension CSS {
    struct TokenStream {
        var tokens: any IteratorProtocol<InputToken?>
        var currentToken: InputToken?
        var retainCurrentInputToken = false

        init(inputTokens: [InputToken]) {
            var iterator = inputTokens.makeIterator()
            tokens = AnyIterator<InputToken?> {
                switch iterator.next() {
                case .none:
                    nil
                case let .some(inputToken):
                    inputToken
                }
            }
        }

        init(tokenizer: Tokenizer) {
            var tokenizerIterator = tokenizer.makeIterator()
            tokens = AnyIterator<InputToken?> {
                switch tokenizerIterator.next() {
                case .none:
                    nil
                case let .some(token):
                    InputToken.token(token as! Token)
                }
            }
        }

        init(simpleBlock: SimpleBlock) {
            var componentValueIterator = simpleBlock.value.makeIterator()
            tokens = AnyIterator<InputToken?> {
                switch componentValueIterator.next() {
                case let .token(token):
                    return InputToken.token(token)
                case let .function(function):
                    return InputToken.componentValue(.function(function))
                case let .simpleBlock(simpleBlock):
                    return InputToken.componentValue(.simpleBlock(simpleBlock))
                case nil:
                    return nil
                case let unknown:
                    FIXME("\(unknown.debugDescription): not implemented")
                    return nil as InputToken?
                }
            }
        }

        init(_ string: String) {
            self.init(tokenizer: Tokenizer(string))
        }

        init(tokens: [Token]) {
            var tokensIterator = tokens.makeIterator()
            self.tokens = AnyIterator<InputToken?> {
                switch tokensIterator.next() {
                case .none:
                    nil
                case let .some(token):
                    InputToken.token(token)
                }
            }
        }

        // https://www.w3.org/TR/css-syntax-3/#consume-the-next-input-token
        mutating func consumeNextInputToken() throws -> InputToken {
            if retainCurrentInputToken {
                retainCurrentInputToken = false
            } else {
                if let token = tokens.next() {
                    currentToken = token
                } else {
                    currentToken = InputToken.token(.eof)
                }
            }
            if let token = currentToken {
                return token
            }
            return InputToken.token(.eof)
        }

        // https://www.w3.org/TR/css-syntax-3/#reconsume-the-current-input-token
        mutating func reconsumeCurrentInputToken() {
            // The next time an algorithm instructs you to consume the next input token,
            // instead do nothing (retain the current input token unchanged).
            retainCurrentInputToken = true
        }

        func currentInputToken() throws -> InputToken {
            switch currentToken {
            case let .some(token):
                return token
            case .none:
                throw ParserError.eof
            }
        }

        mutating func consumeWhile(_ expected: InputToken) throws {
            repeat {
                if try consumeNextInputToken() == expected {
                    continue
                }
                reconsumeCurrentInputToken()
                return
            } while true
        }
    }
}
