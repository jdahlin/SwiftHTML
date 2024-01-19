//
//  TokenStream.swift
//  CSS
//
//  Created by Johan Dahlin on 2024-01-08.
//

import Foundation

public struct TokenStream: Sequence, IteratorProtocol {
    
    public var tokens: any IteratorProtocol<InputToken?>
    var currentToken: InputToken? = nil
    var retainCurrentInputToken = false;
    
    init(inputTokens: [InputToken]) {
        var iterator = inputTokens.makeIterator()
        self.tokens = AnyIterator<InputToken?> {
            switch iterator.next() {
                case .none:
                    return nil
                case .some(let inputToken):
                    return inputToken
            }
        }
    }
    
    init(tokenizer: Tokenizer) {
        var tokenizerIterator = tokenizer.makeIterator()
        self.tokens = AnyIterator<InputToken?> {
            switch tokenizerIterator.next() {
                case .none:
                    return nil
                case .some(let token):
                    return InputToken.token(token as! Token)
            }
        }
    }
    
    public mutating func next() -> Token? {
        do {
            return try self.consumeNextToken()
        } catch {
            return nil
        }
    }
    
    public init(_ string: String) {
        self.init(tokenizer: Tokenizer(string))
    }

    init(tokens: [Token]) {
        var tokensIterator = tokens.makeIterator()
        self.tokens = AnyIterator<InputToken?> {
            switch tokensIterator.next() {
                case .none:
                    return nil
                case .some(let token):
                    return InputToken.token(token)
            }
        }
    }

    // https://www.w3.org/TR/css-syntax-3/#consume-the-next-input-token
    mutating func consumeNextInputToken() throws -> InputToken {
        if self.retainCurrentInputToken {
            self.retainCurrentInputToken = false
        } else {
            if let token = self.tokens.next() {
                self.currentToken = token
            } else {
                self.currentToken = InputToken.token(.eof)
            }
        }
        return self.currentToken!
    }
    
    // https://www.w3.org/TR/css-syntax-3/#reconsume-the-current-input-token
    mutating func reconsumeCurrentInputToken() {
        // The next time an algorithm instructs you to consume the next input token,
        // instead do nothing (retain the current input token unchanged).
        self.retainCurrentInputToken = true
    }
    
    func currentInputToken() throws -> InputToken {
        switch self.currentToken {
        case .some(let token):
            return token
        case .none:
            throw ParserError.eof
        }
    }
    
    mutating func consumeNextToken() throws -> Token {
        switch try self.consumeNextInputToken() {
            case .componentValue(.token(let token)):
                return token
            case .token(let token):
                return token
            default:
                throw ParserError.unexpectedToken
        }
    }
    
    mutating func consumeWhile(_ expected: Token) throws {
        repeat {
            if try self.consumeNextToken() == expected {
                continue
            }
            return
        } while true
    }
}
