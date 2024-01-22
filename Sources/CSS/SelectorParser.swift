//
//  SelectorParser.swift
//  css
//
//  Created by Johan Dahlin on 2024-01-07.
//

import Foundation

// selector-list
// - sequence of simple/compound/complex separated by comma

public enum SubclassSelector {
    case id(String)
    case class_(String)
    case attribute(AttributeSelector)
    case psuedo(String)
}

// simple selector
public enum SimpleSelector {
    case type(WQName)
    case subclass(SubclassSelector)
}

// - type selector (h1, p, div)
// - universal selector (*)
// - attribute selector ([attr], [attr=value])
// - class selector (.class)
// - id selector (#id)
// - psuedo class selector (:valid)

public enum PseudoClassSelector {
    case simple(String)
    case function(Function, String)
}

// compound selector
// - a#selected
// - [type=checkbox]:checked:focus
public struct CompoundSelector {
    public var typeSelector: WQName? = nil
    public var subclassSelectors: [SubclassSelector] = []
    public var pseudoSelectors: [(String, PseudoClassSelector)] = []
}

// combine two selectors and match depending on their relationship
//
//  <anscestor>
//    <anscestor>
//      <parent>
//        <child/>
//        <next-sibling/>
//      </parent>
//      <parent>
//        <sibling/>
//        <subsequent-sibling/>
//        <subsequent-sibling/>
//        <subsequent-sibling/>
//      </parent>
//    </anscestor>
//  </anscestor>

public enum Combinator {
    // descendant combinator (whitespace), e.g: child anscestor
    // https://www.w3.org/TR/selectors-4/#descendant-combinators
    case descendant

    // child combinator (>), e.g: child > parent
    // https://www.w3.org/TR/selectors-4/#child-combinators
    case child

    // next sibling combinator (+), e.g: child + next-sibling
    // https://www.w3.org/TR/selectors-4/#adjacent-sibling-combinators
    case nextSibling

    // subsequent-sibling combinator (~), e.g: sibling ~ subsequent-sibling
    // https://www.w3.org/TR/selectors-4/#general-sibling-combinators
    case subsequentSibling
}

// complex selector
// - a#selected > .icon
// - .box h2 + p
public struct ComplexSelector {
    public var selector: CompoundSelector
    public var elements: [(Combinator, CompoundSelector)]
}

// Enum representing attribute matchers
public enum AttrMatcher {
    // E[foo="bar"]
    case exact

    // E[foo*="bar"]
    case contains

    // E[foo^="bar"]
    case startsWith

    // E[foo$="bar"]
    case endsWith

    case any

    public init?(_ cv: ComponentValue) {
        switch cv {
        case let .token(.delim(c)): self.init(Character(c))
        default:
            return nil
        }
    }

    public init?(_ c: Character) {
        switch c {
        case "*": self = .contains
        case "^": self = .startsWith
        case "$": self = .endsWith
        default:
            return nil
        }
    }
}

public enum AttrModifier {
    case insensitive
    case sensitive

    init?(_ char: String) {
        switch char {
        case "i": self = .insensitive
        case "s": self = .sensitive
        default:
            return nil
        }
    }
}

// Qualified Name that allows wildcards
public struct WQName {
    var name: String
    var nsPrefix: NSPrefix? = nil
}

public struct NSPrefix {
    var prefix: String?
    var wildcard = false
}

public struct AttributeSelector {
    var name: WQName
    var attrMatcher: AttrMatcher?
    var value: String?
    var modifier: AttrModifier = .sensitive
}

struct ComponentValues {
    var pos = 0
    var values: [ComponentValue]

    var count: Int { values.count }
    subscript(index: Int) -> ComponentValue {
        values[index]
    }

    func peek(_ i: Int = 0) -> ComponentValue? {
        let pos = self.pos + i
        return if pos > count - 1 {
            nil
        } else {
            values[pos]
        }
    }

    mutating func next() -> ComponentValue? {
        let pos = self.pos
        if pos > count - 1 {
            return nil
        } else {
            self.pos = pos + 1
            let value = values[pos]
            return value
        }
    }

    mutating func strip_whitespace() {
        while case .token(.whitespace) = peek() {
            _ = next()
        }
    }
}

// <selector-list> = <complex-selector-list>
public func consumeSelectorList(_ values: [ComponentValue]) -> [ComplexSelector] {
    var values = ComponentValues(values: values)
    return consumeComplexSelectorList(&values)
}

// <complex-selector-list> = <complex-selector>#
func consumeComplexSelectorList(_ values: inout ComponentValues) -> [ComplexSelector] {
    var selectors: [ComplexSelector] = []
    while true {
        if let selector = consumeComplexSelector(&values) {
            selectors.append(selector)
        } else {
            break
        }
    }
    return selectors
}

// <complex-selector> = <compound-selector> [ <combinator>? <compound-selector> ]*
func consumeComplexSelector(_ values: inout ComponentValues) -> ComplexSelector? {
    guard let selector = consumeCompoundSelector(&values) else {
        return nil
    }

    var elements: [(Combinator, CompoundSelector)] = []
    while true {
        guard let combinator = consumeCombinator(&values) else { break }
        _ = values.next()
        guard let compound = consumeCompoundSelector(&values) else { break }
        _ = values.next()
        elements.append((combinator, compound))
    }
    return ComplexSelector(selector: selector, elements: elements)
}

// <compound-selector> = [
//   <type-selector>?
//   <subclass-selector>*
//   [ <pseudo-element-selector> <pseudo-class-selector>* ]*
// ]!
func consumeCompoundSelector(_ values: inout ComponentValues) -> CompoundSelector? {
    if let name = consumeWQName(&values) {
        return CompoundSelector(typeSelector: name)
    }
    if case .token(.delim("*")) = values.peek() {
        _ = values.next()
        return CompoundSelector(typeSelector: WQName(name: "*"))
    }
    if let subclassSelector = consumeSubclassSeletor(&values) {
        return CompoundSelector(subclassSelectors: [subclassSelector])
    }
    // print("Compound: \(values.values) Not implemented")
    return nil
}

// <type-selector> = <wq-name> | <ns-prefix>? '*'
func consumeTypeSelector(_ values: inout ComponentValues) -> WQName? {
    // FIXME: ns-prefix
    return consumeWQName(&values)
}

// <ns-prefix>? <ident-token>
func consumeWQName(_ values: inout ComponentValues) -> WQName? {
    // FIXME: prefix
    if case let .token(.ident(name)) = values.peek() {
        _ = values.next()
        return WQName(name: name)
    }
    return nil
}

// <combinator> = '>' | '+' | '~' | [ '|' '|' ]
func consumeCombinator(_ values: inout ComponentValues) -> Combinator? {
    if case let .token(token) = values.peek() {
        switch token {
        case .whitespace:
            _ = values.next()
            return Combinator.descendant
        case .delim("^"):
            _ = values.next()
            return Combinator.child
        case .delim("+"):
            _ = values.next()
            return Combinator.nextSibling
        case .delim("~"):
            _ = values.next()
            return Combinator.subsequentSibling
        default:
            return nil
        }
    }
    return nil
}

// <attribute-selector> = '[' <wq-name> ']' |
//                        '[' <wq-name> <attr-matcher> [ <string-token> | <ident-token> ] <attr-modifier>? ']'
func consumeAttributeSelector(_ values: inout ComponentValues) -> AttributeSelector? {
    var name: String?
    var value: String?
    var attrMatcher: AttrMatcher?
    var modifier = AttrModifier.insensitive

    values.strip_whitespace()

    guard case let .token(.ident(ident)) = values.peek() else {
        return nil
    }
    _ = values.next()
    name = ident

    values.strip_whitespace()

    switch values.peek() {
    // attr=value
    case .token(.delim("=")):
        _ = values.next()
        attrMatcher = AttrMatcher.exact
        if case let .token(.ident(ident)) = values.peek() {
            _ = values.next()
            value = ident
        }
    // attr*=value
    // attr^=value
    // attr$=value
    case .token(.delim("^")), .token(.delim("*")), .token(.delim("$")):
        if case let .token(.delim(char)) = values.peek(), case .token(.delim) = values.peek(2) {
            _ = values.next()
            _ = values.next()
            attrMatcher = AttrMatcher(Character(char))
            if case let .token(.ident(ident)) = values.peek() {
                _ = values.next()
                value = ident
            }
        }

    default:
        return nil
    }
    if case .token(.whitespace) = values.peek(),
       case .token(.ident("s")) = values.peek(2)
    {
        modifier = .sensitive
    }

    values.strip_whitespace()

    if name != nil {
        return AttributeSelector(
            name: WQName(name: name!),
            attrMatcher: attrMatcher,
            value: value,
            modifier: modifier
        )
    }
    return nil
}

// <id-selector> | <class-selector> |
// <attribute-selector> | <pseudo-class-selector>

func consumeSubclassSeletor(_ values: inout ComponentValues) -> SubclassSelector? {
    switch values.peek() {
    case .token(.delim(".")):
        var i = 1
        repeat {
            switch values.peek(i) {
            case .token(.whitespace):
                i += 1
                continue
            case let .token(.ident(ident)):
                if i > 1 {
                    _ = values.next()
                }
                _ = values.next()
                _ = values.next()
                let selector = SubclassSelector.class_(ident)
                values.strip_whitespace()
                return selector
            default:
                return nil
            }
        } while true
    case let .token(token):
        if case let .hashToken(hash: hash) = token {
            _ = values.next()
            return .id(hash.hash)
        }
    case let .simpleBlock(simpleBlock):
        switch simpleBlock.token {
        case .rbracket:
            _ = values.next()
            var blockValues = ComponentValues(values: simpleBlock.value)
            if let selector = consumeAttributeSelector(&blockValues) {
                return .attribute(selector)
            }
        default:
            break
        }
    default:
        break
    }
    _ = values.next()
    return nil
}

// [ <ident-token> | '*' ]? '|'
func consumeNsPrefix(_ tokenStream: inout TokenStream) throws -> NSPrefix {
    var prefix: String?
    var wildcard = false

    switch try tokenStream.consumeNextToken() {
    case let .ident(value):
        prefix = value
    case let .delim(value) where value == "*":
        wildcard = true
    case let .delim(value) where value == "|":
        return NSPrefix()
    default:
        throw ParserError.unexpectedToken
    }

    let token = try tokenStream.consumeNextInputToken()
    guard case let .componentValue(.token(.delim(value))) = token else {
        throw ParserError.unexpectedToken
    }

    guard value == "|" else {
        throw ParserError.unexpectedToken
    }

    return NSPrefix(prefix: prefix, wildcard: wildcard)
}