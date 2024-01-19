// 13.2.6.4.8 The "text" insertion mode
// When the user agent is to apply the rules for the "text" insertion mode, the user agent must handle the token as follows:
// A character token
// Insert the token's character.
// This can never be a U+0000 NULL character; the tokenizer converts those to U+FFFD REPLACEMENT CHARACTER characters.
// An end-of-file token
// Parse error.
// If the current node is a script element, then set its already started to true.
// Pop the current node off the stack of open elements.
// Switch the insertion mode to the original insertion mode and reprocess the token.
// An end tag whose tag name is "script"
// If the active speculative HTML parser is null and the JavaScript execution context stack is empty, then perform a microtask checkpoint.
// Let script be the current node (which will be a script element).
// Pop the current node off the stack of open elements.
// Switch the insertion mode to the original insertion mode.
// Let the old insertion point have the same value as the current insertion point. Let the insertion point be just before the next input character.
// Increment the parser's script nesting level by one.
// If the active speculative HTML parser is null, then prepare the script element script. This might cause some script to execute, which might cause new characters to be inserted into the tokenizer, and might cause the tokenizer to output more tokens, resulting in a reentrant invocation of the parser.
// Decrement the parser's script nesting level by one. If the parser's script nesting level is zero, then set the parser pause flag to false.
// Let the insertion point have the value of the old insertion point. (In other words, restore the insertion point to its previous value. This value might be the "undefined" value.)
// At this stage, if the pending parsing-blocking script is not null, then:
// If the script nesting level is not zero:
// Set the parser pause flag to true, and abort the processing of any nested invocations of the tokenizer, yielding control back to the caller. (Tokenization will resume when the caller returns to the "outer" tree construction stage.)
// The tree construction stage of this particular parser is being called reentrantly, say from a call to document.write().
// Otherwise:
// While the pending parsing-blocking script is not null:
// Let the script be the pending parsing-blocking script.
// Set the pending parsing-blocking script to null.
// Start the speculative HTML parser for this instance of the HTML parser.
// Block the tokenizer for this instance of the HTML parser, such that the event loop will not run tasks that invoke the tokenizer.
// If the parser's Document has a style sheet that is blocking scripts or the script's ready to be parser-executed is false: spin the event loop until the parser's Document has no style sheet that is blocking scripts and the script's ready to be parser-executed becomes true.
// If this parser has been aborted in the meantime, return.
// This could happen if, e.g., while the spin the event loop algorithm is running, the Document gets destroyed, or the document.open() method gets invoked on the Document.
// Stop the speculative HTML parser for this instance of the HTML parser.
// Unblock the tokenizer for this instance of the HTML parser, such that tasks that invoke the tokenizer can again be run.
// Let the insertion point be just before the next input character.
// Increment the parser's script nesting level by one (it should be zero before this step, so this sets it to one).
// Execute the script element the script.
// Decrement the parser's script nesting level by one. If the parser's script nesting level is zero (which it always should be at this point), then set the parser pause flag to false.
// Let the insertion point be undefined again.
// Any other end tag
// Pop the current node off the stack of open elements.
// Switch the insertion mode to the original insertion mode.