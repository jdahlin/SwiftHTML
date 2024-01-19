// 13.2.6.4.15 The "in cell" insertion mode
// When the user agent is to apply the rules for the "in cell" insertion mode, the user agent must handle the token as follows:
// An end tag whose tag name is one of: "td", "th"
// If the stack of open elements does not have an element in table scope that is an HTML element with the same tag name as that of the token, then this is a parse error; ignore the token.
// Otherwise:
// Generate implied end tags.
// Now, if the current node is not an HTML element with the same tag name as the token, then this is a parse error.
// Pop elements from the stack of open elements stack until an HTML element with the same tag name as the token has been popped from the stack.
// Clear the list of active formatting elements up to the last marker.
// Switch the insertion mode to "in row".
// A start tag whose tag name is one of: "caption", "col", "colgroup", "tbody", "td", "tfoot", "th", "thead", "tr"
// Assert: The stack of open elements has a td or th element in table scope.
// Close the cell (see below) and reprocess the token.
// An end tag whose tag name is one of: "body", "caption", "col", "colgroup", "html"
// Parse error. Ignore the token.
// An end tag whose tag name is one of: "table", "tbody", "tfoot", "thead", "tr"
// If the stack of open elements does not have an element in table scope that is an HTML element with the same tag name as that of the token, then this is a parse error; ignore the token.
// Otherwise, close the cell (see below) and reprocess the token.
// Anything else
// Process the token using the rules for the "in body" insertion mode.
// Where the steps above say to close the cell, they mean to run the following algorithm:
// Generate implied end tags.
// If the current node is not now a td element or a th element, then this is a parse error.
// Pop elements from the stack of open elements stack until a td element or a th element has been popped from the stack.
// Clear the list of active formatting elements up to the last marker.
// Switch the insertion mode to "in row".
// The stack of open elements cannot have both a td and a th element in table scope at the same time, nor can it have neither when the close the cell algorithm is invoked.
