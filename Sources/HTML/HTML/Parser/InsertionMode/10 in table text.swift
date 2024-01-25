// 13.2.6.4.10 The "in table text" insertion mode
// When the user agent is to apply the rules for the "in table text" insertion mode, the user agent must handle the token as follows:
// A character token that is U+0000 NULL
// Parse error. Ignore the token.
// Any other character token
// Append the character token to the pending table character tokens list.
// Anything else
// If any of the tokens in the pending table character tokens list are character tokens that are not ASCII whitespace, then this is a parse error: reprocess the character tokens in the pending table character tokens list using the rules given in the "anything else" entry in the "in table" insertion mode.
// Otherwise, insert the characters given by the pending table character tokens list.
// Switch the insertion mode to the original insertion mode and reprocess the token.
