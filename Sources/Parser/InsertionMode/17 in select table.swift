  // 13.2.6.4.17 The "in select in table" insertion mode
  // When the user agent is to apply the rules for the "in select in table" insertion mode, the user agent must handle the token as follows:
  // A start tag whose tag name is one of: "caption", "table", "tbody", "tfoot", "thead", "tr", "td", "th"
  // Parse error.
  // Pop elements from the stack of open elements until a select element has been popped from the stack.
  // Reset the insertion mode appropriately.
  // Reprocess the token.
  // An end tag whose tag name is one of: "caption", "table", "tbody", "tfoot", "thead", "tr", "td", "th"
  // Parse error.
  // If the stack of open elements does not have an element in table scope that is an HTML element with the same tag name as that of the token, then ignore the token.
  // Otherwise:
  // Pop elements from the stack of open elements until a select element has been popped from the stack.
  // Reset the insertion mode appropriately.
  // Reprocess the token.
  // Anything else
  // Process the token using the rules for the "in select" insertion mode.
