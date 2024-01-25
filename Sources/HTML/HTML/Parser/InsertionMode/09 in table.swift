// 13.2.6.4.9 The "in table" insertion mode
// When the user agent is to apply the rules for the "in table" insertion mode, the user agent must handle the token as follows:
// A character token, if the current node is table, tbody, template, tfoot, thead, or tr element
// Let the pending table character tokens be an empty list of tokens.
// Let the original insertion mode be the current insertion mode.
// Switch the insertion mode to "in table text" and reprocess the token.
// A comment token
// Insert a comment.
// A DOCTYPE token
// Parse error. Ignore the token.
// A start tag whose tag name is "caption"
// Clear the stack back to a table context. (See below.)
// Insert a marker at the end of the list of active formatting elements.
// Insert an HTML element for the token, then switch the insertion mode to "in caption".
// A start tag whose tag name is "colgroup"
// Clear the stack back to a table context. (See below.)
// Insert an HTML element for the token, then switch the insertion mode to "in column group".
// A start tag whose tag name is "col"
// Clear the stack back to a table context. (See below.)
// Insert an HTML element for a "colgroup" start tag token with no attributes, then switch the insertion mode to "in column group".
// Reprocess the current token.
// A start tag whose tag name is one of: "tbody", "tfoot", "thead"
// Clear the stack back to a table context. (See below.)
// Insert an HTML element for the token, then switch the insertion mode to "in table body".
// A start tag whose tag name is one of: "td", "th", "tr"
// Clear the stack back to a table context. (See below.)
// Insert an HTML element for a "tbody" start tag token with no attributes, then switch the insertion mode to "in table body".
// Reprocess the current token.
// A start tag whose tag name is "table"
// Parse error.
// If the stack of open elements does not have a table element in table scope, ignore the token.
// Otherwise:
// Pop elements from this stack until a table element has been popped from the stack.
// Reset the insertion mode appropriately.
// Reprocess the token.
// An end tag whose tag name is "table"
// If the stack of open elements does not have a table element in table scope, this is a parse error; ignore the token.
// Otherwise:
// Pop elements from this stack until a table element has been popped from the stack.
// Reset the insertion mode appropriately.
// An end tag whose tag name is one of: "body", "caption", "col", "colgroup", "html", "tbody", "td", "tfoot", "th", "thead", "tr"
// Parse error. Ignore the token.
// A start tag whose tag name is one of: "style", "script", "template"
// An end tag whose tag name is "template"
// Process the token using the rules for the "in head" insertion mode.
// A start tag whose tag name is "input"
// If the token does not have an attribute with the name "type", or if it does, but that attribute's value is not an ASCII case-insensitive match for the string "hidden", then: act as described in the "anything else" entry below.
// Otherwise:
// Parse error.
// Insert an HTML element for the token.
// Pop that input element off the stack of open elements.
// Acknowledge the token's self-closing flag, if it is set.
// A start tag whose tag name is "form"
// Parse error.
// If there is a template element on the stack of open elements, or if the form element pointer is not null, ignore the token.
// Otherwise:
// Insert an HTML element for the token, and set the form element pointer to point to the element created.
// Pop that form element off the stack of open elements.
// An end-of-file token
// Process the token using the rules for the "in body" insertion mode.
// Anything else
// Parse error. Enable foster parenting, process the token using the rules for the "in body" insertion mode, and then disable foster parenting.
// When the steps above require the UA to clear the stack back to a table context, it means that the UA must, while the current node is not a table, template, or html element, pop elements from the stack of open elements.
// This is the same list of elements as used in the has an element in table scope steps.
// The current node being an html element after this process is a fragment case.
