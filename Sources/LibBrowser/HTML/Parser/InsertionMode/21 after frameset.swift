// 13.2.6.4.21 The "after frameset" insertion mode
// When the user agent is to apply the rules for the "after frameset" insertion mode, the user agent must handle the token as follows:
// A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020 SPACE
// Insert the character.
// A comment token
// Insert a comment.
// A DOCTYPE token
// Parse error. Ignore the token.
// A start tag whose tag name is "html"
// Process the token using the rules for the "in body" insertion mode.
// An end tag whose tag name is "html"
// Switch the insertion mode to "after after frameset".
// A start tag whose tag name is "noframes"
// Process the token using the rules for the "in head" insertion mode.
// An end-of-file token
// Stop parsing.
// Anything else
// Parse error. Ignore the token.
