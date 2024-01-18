  // 13.2.6.4.11 The "in caption" insertion mode
  // When the user agent is to apply the rules for the "in caption" insertion mode, the user agent must handle the token as follows:
  // An end tag whose tag name is "caption"
  // If the stack of open elements does not have a caption element in table scope, this is a parse error; ignore the token. (fragment case)
  // Otherwise:
  // Generate implied end tags.
  // Now, if the current node is not a caption element, then this is a parse error.
  // Pop elements from this stack until a caption element has been popped from the stack.
  // Clear the list of active formatting elements up to the last marker.
  // Switch the insertion mode to "in table".
  // A start tag whose tag name is one of: "caption", "col", "colgroup", "tbody", "td", "tfoot", "th", "thead", "tr"
  // An end tag whose tag name is "table"
  // If the stack of open elements does not have a caption element in table scope, this is a parse error; ignore the token. (fragment case)
  // Otherwise:
  // Generate implied end tags.
  // Now, if the current node is not a caption element, then this is a parse error.
  // Pop elements from this stack until a caption element has been popped from the stack.
  // Clear the list of active formatting elements up to the last marker.
  // Switch the insertion mode to "in table".
  // Reprocess the token.
  // An end tag whose tag name is one of: "body", "col", "colgroup", "html", "tbody", "td", "tfoot", "th", "thead", "tr"
  // Parse error. Ignore the token.
  // Anything else
  // Process the token using the rules for the "in body" insertion mode.
