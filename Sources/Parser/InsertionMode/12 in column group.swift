// 13.2.6.4.12 The "in column group" insertion mode
// When the user agent is to apply the rules for the "in column group" insertion mode, the user agent must handle the token as follows:
// A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020 SPACE
// Insert the character.
// A comment token
// Insert a comment.
// A DOCTYPE token
// Parse error. Ignore the token.
// A start tag whose tag name is "html"
// Process the token using the rules for the "in body" insertion mode.
// A start tag whose tag name is "col"
// Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
// Acknowledge the token's self-closing flag, if it is set.
// An end tag whose tag name is "colgroup"
// If the current node is not a colgroup element, then this is a parse error; ignore the token.
// Otherwise, pop the current node from the stack of open elements. Switch the insertion mode to "in table".
// An end tag whose tag name is "col"
// Parse error. Ignore the token.
// A start tag whose tag name is "template"
// An end tag whose tag name is "template"
// Process the token using the rules for the "in head" insertion mode.
// An end-of-file token
// Process the token using the rules for the "in body" insertion mode.
// Anything else
// If the current node is not a colgroup element, then this is a parse error; ignore the token.
// Otherwise, pop the current node from the stack of open elements.
// Switch the insertion mode to "in table".
// Reprocess the token.
