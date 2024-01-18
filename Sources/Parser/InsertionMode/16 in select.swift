  // 13.2.6.4.16 The "in select" insertion mode
  // When the user agent is to apply the rules for the "in select" insertion mode, the user agent must handle the token as follows:
  // A character token that is U+0000 NULL
  // Parse error. Ignore the token.
  // Any other character token
  // Insert the token's character.
  // A comment token
  // Insert a comment.
  // A DOCTYPE token
  // Parse error. Ignore the token.
  // A start tag whose tag name is "html"
  // Process the token using the rules for the "in body" insertion mode.
  // A start tag whose tag name is "option"
  // If the current node is an option element, pop that node from the stack of open elements.
  // Insert an HTML element for the token.
  // A start tag whose tag name is "optgroup"
  // If the current node is an option element, pop that node from the stack of open elements.
  // If the current node is an optgroup element, pop that node from the stack of open elements.
  // Insert an HTML element for the token.
  // A start tag whose tag name is "hr"
  // If the current node is an option element, pop that node from the stack of open elements.
  // If the current node is an optgroup element, pop that node from the stack of open elements.
  // Insert an HTML element for the token. Immediately pop the current node off the stack of open elements.
  // Acknowledge the token's self-closing flag, if it is set.
  // An end tag whose tag name is "optgroup"
  // First, if the current node is an option element, and the node immediately before it in the stack of open elements is an optgroup element, then pop the current node from the stack of open elements.
  // If the current node is an optgroup element, then pop that node from the stack of open elements. Otherwise, this is a parse error; ignore the token.
  // An end tag whose tag name is "option"
  // If the current node is an option element, then pop that node from the stack of open elements. Otherwise, this is a parse error; ignore the token.
  // An end tag whose tag name is "select"
  // If the stack of open elements does not have a select element in select scope, this is a parse error; ignore the token. (fragment case)
  // Otherwise:
  // Pop elements from the stack of open elements until a select element has been popped from the stack.
  // Reset the insertion mode appropriately.
  // A start tag whose tag name is "select"
  // Parse error.
  // If the stack of open elements does not have a select element in select scope, ignore the token. (fragment case)
  // Otherwise:
  // Pop elements from the stack of open elements until a select element has been popped from the stack.
  // Reset the insertion mode appropriately.
  // It just gets treated like an end tag.
  // A start tag whose tag name is one of: "input", "keygen", "textarea"
  // Parse error.
  // If the stack of open elements does not have a select element in select scope, ignore the token. (fragment case)
  // Otherwise:
  // Pop elements from the stack of open elements until a select element has been popped from the stack.
  // Reset the insertion mode appropriately.
  // Reprocess the token.
  // A start tag whose tag name is one of: "script", "template"
  // An end tag whose tag name is "template"
  // Process the token using the rules for the "in head" insertion mode.
  // An end-of-file token
  // Process the token using the rules for the "in body" insertion mode.
  // Anything else
  // Parse error. Ignore the token.
