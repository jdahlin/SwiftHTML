// 13.2.6.4.22 The "after after body" insertion mode
// When the user agent is to apply the rules for the "after after body" insertion mode, the user agent must handle the token as follows:
// A comment token
// Insert a comment as the last child of the Document object.
// A DOCTYPE token
// A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020 SPACE
// A start tag whose tag name is "html"
// Process the token using the rules for the "in body" insertion mode.
// An end-of-file token
// Stop parsing.
// Anything else
// Parse error. Switch the insertion mode to "in body" and reprocess the token.
