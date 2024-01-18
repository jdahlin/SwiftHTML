  // 13.2.6.4.18 The "in template" insertion mode
  // When the user agent is to apply the rules for the "in template" insertion mode, the user agent must handle the token as follows:
  // A character token
  // A comment token
  // A DOCTYPE token
  // Process the token using the rules for the "in body" insertion mode.
  // A start tag whose tag name is one of: "base", "basefont", "bgsound", "link", "meta", "noframes", "script", "style", "template", "title"
  // An end tag whose tag name is "template"
  // Process the token using the rules for the "in head" insertion mode.
  // A start tag whose tag name is one of: "caption", "colgroup", "tbody", "tfoot", "thead"
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Push "in table" onto the stack of template insertion modes so that it is the new current template insertion mode.
  // Switch the insertion mode to "in table", and reprocess the token.
  // A start tag whose tag name is "col"
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Push "in column group" onto the stack of template insertion modes so that it is the new current template insertion mode.
  // Switch the insertion mode to "in column group", and reprocess the token.
  // A start tag whose tag name is "tr"
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Push "in table body" onto the stack of template insertion modes so that it is the new current template insertion mode.
  // Switch the insertion mode to "in table body", and reprocess the token.
  // A start tag whose tag name is one of: "td", "th"
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Push "in row" onto the stack of template insertion modes so that it is the new current template insertion mode.
  // Switch the insertion mode to "in row", and reprocess the token.
  // Any other start tag
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Push "in body" onto the stack of template insertion modes so that it is the new current template insertion mode.
  // Switch the insertion mode to "in body", and reprocess the token.
  // Any other end tag
  // Parse error. Ignore the token.
  // An end-of-file token
  // If there is no template element on the stack of open elements, then stop parsing. (fragment case)
  // Otherwise, this is a parse error.
  // Pop elements from the stack of open elements until a template element has been popped from the stack.
  // Clear the list of active formatting elements up to the last marker.
  // Pop the current template insertion mode off the stack of template insertion modes.
  // Reset the insertion mode appropriately.
  // Reprocess the token.
