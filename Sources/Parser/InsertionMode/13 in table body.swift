  // 13.2.6.4.13 The "in table body" insertion mode
  // When the user agent is to apply the rules for the "in table body" insertion mode, the user agent must handle the token as follows:
  // A start tag whose tag name is "tr"
  // Clear the stack back to a table body context. (See below.)
  // Insert an HTML element for the token, then switch the insertion mode to "in row".
  // A start tag whose tag name is one of: "th", "td"
  // Parse error.
  // Clear the stack back to a table body context. (See below.)
  // Insert an HTML element for a "tr" start tag token with no attributes, then switch the insertion mode to "in row".
  // Reprocess the current token.
  // An end tag whose tag name is one of: "tbody", "tfoot", "thead"
  // If the stack of open elements does not have an element in table scope that is an HTML element with the same tag name as the token, this is a parse error; ignore the token.
  // Otherwise:
  // Clear the stack back to a table body context. (See below.)
  // Pop the current node from the stack of open elements. Switch the insertion mode to "in table".
  // A start tag whose tag name is one of: "caption", "col", "colgroup", "tbody", "tfoot", "thead"
  // An end tag whose tag name is "table"
  // If the stack of open elements does not have a tbody, thead, or tfoot element in table scope, this is a parse error; ignore the token.
  // Otherwise:
  // Clear the stack back to a table body context. (See below.)
  // Pop the current node from the stack of open elements. Switch the insertion mode to "in table".
  // Reprocess the token.
  // An end tag whose tag name is one of: "body", "caption", "col", "colgroup", "html", "td", "th", "tr"
  // Parse error. Ignore the token.
  // Anything else
  // Process the token using the rules for the "in table" insertion mode.
  // When the steps above require the UA to clear the stack back to a table body context, it means that the UA must, while the current node is not a tbody, tfoot, thead, template, or html element, pop elements from the stack of open elements.
  // The current node being an html element after this process is a fragment case.
