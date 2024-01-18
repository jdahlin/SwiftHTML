  // 13.2.6.4.14 The "in row" insertion mode
  // When the user agent is to apply the rules for the "in row" insertion mode, the user agent must handle the token as follows:
  // A start tag whose tag name is one of: "th", "td"
  // Clear the stack back to a table row context. (See below.)
  // Insert an HTML element for the token, then switch the insertion mode to "in cell".
  // Insert a marker at the end of the list of active formatting elements.
  // An end tag whose tag name is "tr"
  // If the stack of open elements does not have a tr element in table scope, this is a parse error; ignore the token.
  // Otherwise:
  // Clear the stack back to a table row context. (See below.)
  // Pop the current node (which will be a tr element) from the stack of open elements. Switch the insertion mode to "in table body".
  // A start tag whose tag name is one of: "caption", "col", "colgroup", "tbody", "tfoot", "thead", "tr"
  // An end tag whose tag name is "table"
  // If the stack of open elements does not have a tr element in table scope, this is a parse error; ignore the token.
  // Otherwise:
  // Clear the stack back to a table row context. (See below.)
  // Pop the current node (which will be a tr element) from the stack of open elements. Switch the insertion mode to "in table body".
  // Reprocess the token.
  // An end tag whose tag name is one of: "tbody", "tfoot", "thead"
  // If the stack of open elements does not have an element in table scope that is an HTML element with the same tag name as the token, this is a parse error; ignore the token.
  // If the stack of open elements does not have a tr element in table scope, ignore the token.
  // Otherwise:
  // Clear the stack back to a table row context. (See below.)
  // Pop the current node (which will be a tr element) from the stack of open elements. Switch the insertion mode to "in table body".
  // Reprocess the token.
  // An end tag whose tag name is one of: "body", "caption", "col", "colgroup", "html", "td", "th"
  // Parse error. Ignore the token.
  // Anything else
  // Process the token using the rules for the "in table" insertion mode.
  // When the steps above require the UA to clear the stack back to a table row context, it means that the UA must, while the current node is not a tr, template, or html element, pop elements from the stack of open elements.
  // The current node being an html element after this process is a fragment case.
