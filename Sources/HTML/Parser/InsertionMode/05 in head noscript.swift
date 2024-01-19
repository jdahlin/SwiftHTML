extension TreeBuilder {
    // 13.2.6.4.5 The "in head noscript" insertion mode
    // When the user agent is to apply the rules for the "in head noscript" insertion mode, the user agent must handle the token as follows:
    // A DOCTYPE token
    // Parse error. Ignore the token.
    // A start tag whose tag name is "html"
    // Process the token using the rules for the "in body" insertion mode.
    // An end tag whose tag name is "noscript"
    // Pop the current node (which will be a noscript element) from the stack of open elements; the new current node will be a head element.
    // Switch the insertion mode to "in head".
    // A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020 SPACE
    // A comment token
    // A start tag whose tag name is one of: "basefont", "bgsound", "link", "meta", "noframes", "style"
    // Process the token using the rules for the "in head" insertion mode.
    // An end tag whose tag name is "br"
    // Act as described in the "anything else" entry below.
    // A start tag whose tag name is one of: "head", "noscript"
    // Any other end tag
    // Parse error. Ignore the token.
    // Anything else
    // Parse error.
    // Pop the current node (which will be a noscript element) from the stack of open elements; the new current node will be a head element.
    // Switch the insertion mode to "in head".
    // Reprocess the token.
}
