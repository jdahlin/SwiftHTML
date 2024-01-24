// https://dom.spec.whatwg.org/#ordered-sets

import Collections

func orderedSetParser(input: DOMString) -> OrderedSet<String.SubSequence> {
    // Let inputTokens be the result of splitting input on ASCII whitespace.
    let inputTokens = input.split(separator: " ")

    // Let tokens be a new ordered set.
    var tokens = OrderedSet<String.SubSequence>()

    // For each token in inputTokens, append token to tokens.
    for token in inputTokens {
        tokens.append(token)
    }

    // Return tokens.
    return tokens
}
