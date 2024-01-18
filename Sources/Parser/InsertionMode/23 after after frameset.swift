  // 13.2.6.4.23 The "after after frameset" insertion mode
  // When the user agent is to apply the rules for the "after after frameset" insertion mode, the user agent must handle the token as follows:
  // A comment token
  // Insert a comment as the last child of the Document object.
  // A DOCTYPE token
  // A character token that is one of U+0009 CHARACTER TABULATION, U+000A LINE FEED (LF), U+000C FORM FEED (FF), U+000D CARRIAGE RETURN (CR), or U+0020 SPACE
  // A start tag whose tag name is "html"
  // Process the token using the rules for the "in body" insertion mode.
  // An end-of-file token
  // Stop parsing.
  // A start tag whose tag name is "noframes"
  // Process the token using the rules for the "in head" insertion mode.
  // Anything else
  // Parse error. Ignore the token.
