// 13.2.5.9 RCDATA less-than sign state
// Consume the next input character:
// U+002F SOLIDUS (/)
// Set the temporary buffer to the empty string. Switch to the RCDATA end tag open state.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token. Reconsume in the RCDATA state.

// 13.2.5.10 RCDATA end tag open state
// Consume the next input character:
// ASCII alpha
// Create a new end tag token, set its tag name to the empty string. Reconsume in the RCDATA end tag name state.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the RCDATA state.

// 13.2.5.11 RCDATA end tag name state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
// U+002F SOLIDUS (/)
// If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
// U+003E GREATER-THAN SIGN (>)
// If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
// ASCII upper alpha
// Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
// ASCII lower alpha
// Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the RCDATA state.

// 13.2.5.18 Script data escape start state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data escape start dash state. Emit a U+002D HYPHEN-MINUS character token.
// Anything else
// Reconsume in the script data state.

// 13.2.5.19 Script data escape start dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
// Anything else
// Reconsume in the script data state.

// 13.2.5.20 Script data escaped state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data escaped dash state. Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data escaped less-than sign state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Emit the current input character as a character token.

// 13.2.5.21 Script data escaped dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data escaped less-than sign state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Switch to the script data escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Switch to the script data escaped state. Emit the current input character as a character token.

// 13.2.5.22 Script data escaped dash dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data escaped less-than sign state.
// U+003E GREATER-THAN SIGN (>)
// Switch to the script data state. Emit a U+003E GREATER-THAN SIGN character token.
// U+0000 NULL
// This is an unexpected-null-character parse error. Switch to the script data escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Switch to the script data escaped state. Emit the current input character as a character token.

// 13.2.5.23 Script data escaped less-than sign state
// Consume the next input character:
// U+002F SOLIDUS (/)
// Set the temporary buffer to the empty string. Switch to the script data escaped end tag open state.
// ASCII alpha
// Set the temporary buffer to the empty string. Emit a U+003C LESS-THAN SIGN character token. Reconsume in the script data double escape start state.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token. Reconsume in the script data escaped state.

// 13.2.5.24 Script data escaped end tag open state
// Consume the next input character:
// ASCII alpha
// Create a new end tag token, set its tag name to the empty string. Reconsume in the script data escaped end tag name state.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token and a U+002F SOLIDUS character token. Reconsume in the script data escaped state.

// 13.2.5.25 Script data escaped end tag name state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// If the current end tag token is an appropriate end tag token, then switch to the before attribute name state. Otherwise, treat it as per the "anything else" entry below.
// U+002F SOLIDUS (/)
// If the current end tag token is an appropriate end tag token, then switch to the self-closing start tag state. Otherwise, treat it as per the "anything else" entry below.
// U+003E GREATER-THAN SIGN (>)
// If the current end tag token is an appropriate end tag token, then switch to the data state and emit the current tag token. Otherwise, treat it as per the "anything else" entry below.
// ASCII upper alpha
// Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the current tag token's tag name. Append the current input character to the temporary buffer.
// ASCII lower alpha
// Append the current input character to the current tag token's tag name. Append the current input character to the temporary buffer.
// Anything else
// Emit a U+003C LESS-THAN SIGN character token, a U+002F SOLIDUS character token, and a character token for each of the characters in the temporary buffer (in the order they were added to the buffer). Reconsume in the script data escaped state.

// 13.2.5.26 Script data double escape start state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// U+002F SOLIDUS (/)
// U+003E GREATER-THAN SIGN (>)
// If the temporary buffer is the string "script", then switch to the script data double escaped state. Otherwise, switch to the script data escaped state. Emit the current input character as a character token.
// ASCII upper alpha
// Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the temporary buffer. Emit the current input character as a character token.
// ASCII lower alpha
// Append the current input character to the temporary buffer. Emit the current input character as a character token.
// Anything else
// Reconsume in the script data escaped state.

// 13.2.5.27 Script data double escaped state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data double escaped dash state. Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
// U+0000 NULL
// This is an unexpected-null-character parse error. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Emit the current input character as a character token.

// 13.2.5.28 Script data double escaped dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the script data double escaped dash dash state. Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
// U+0000 NULL
// This is an unexpected-null-character parse error. Switch to the script data double escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Switch to the script data double escaped state. Emit the current input character as a character token.

// 13.2.5.29 Script data double escaped dash dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Emit a U+002D HYPHEN-MINUS character token.
// U+003C LESS-THAN SIGN (<)
// Switch to the script data double escaped less-than sign state. Emit a U+003C LESS-THAN SIGN character token.
// U+003E GREATER-THAN SIGN (>)
// Switch to the script data state. Emit a U+003E GREATER-THAN SIGN character token.
// U+0000 NULL
// This is an unexpected-null-character parse error. Switch to the script data double escaped state. Emit a U+FFFD REPLACEMENT CHARACTER character token.
// EOF
// This is an eof-in-script-html-comment-like-text parse error. Emit an end-of-file token.
// Anything else
// Switch to the script data double escaped state. Emit the current input character as a character token.

// 13.2.5.30 Script data double escaped less-than sign state
// Consume the next input character:
// U+002F SOLIDUS (/)
// Set the temporary buffer to the empty string. Switch to the script data double escape end state. Emit a U+002F SOLIDUS character token.
// Anything else
// Reconsume in the script data double escaped state.

// 13.2.5.31 Script data double escape end state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// U+002F SOLIDUS (/)
// U+003E GREATER-THAN SIGN (>)
// If the temporary buffer is the string "script", then switch to the script data escaped state. Otherwise, switch to the script data double escaped state. Emit the current input character as a character token.
// ASCII upper alpha
// Append the lowercase version of the current input character (add 0x0020 to the character's code point) to the temporary buffer. Emit the current input character as a character token.
// ASCII lower alpha
// Append the current input character to the temporary buffer. Emit the current input character as a character token.
// Anything else
// Reconsume in the script data double escaped state.

// 13.2.5.34 After attribute name state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+002F SOLIDUS (/)
// Switch to the self-closing start tag state.
// U+003D EQUALS SIGN (=)
// Switch to the before attribute value state.
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the current tag token.
// EOF
// This is an eof-in-tag parse error. Emit an end-of-file token.
// Anything else
// Start a new attribute in the current tag token. Set that attribute name and value to the empty string. Reconsume in the attribute name state.

// 13.2.5.40 Self-closing start tag state
// Consume the next input character:
// U+003E GREATER-THAN SIGN (>)
// Set the self-closing flag of the current tag token. Switch to the data state. Emit the current tag token.
// EOF
// This is an eof-in-tag parse error. Emit an end-of-file token.
// Anything else
// This is an unexpected-solidus-in-tag parse error. Reconsume in the before attribute name state.

// 13.2.5.44 Comment start dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the comment end state.
// U+003E GREATER-THAN SIGN (>)
// This is an abrupt-closing-of-empty-comment parse error. Switch to the data state. Emit the current comment token.
// EOF
// This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
// Anything else
// Append a U+002D HYPHEN-MINUS character (-) to the comment token's data. Reconsume in the comment state.

// 13.2.5.46 Comment less-than sign state
// Consume the next input character:
// U+0021 EXCLAMATION MARK (!)
// Append the current input character to the comment token's data. Switch to the comment less-than sign bang state.
// U+003C LESS-THAN SIGN (<)
// Append the current input character to the comment token's data.
// Anything else
// Reconsume in the comment state.

// 13.2.5.47 Comment less-than sign bang state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the comment less-than sign bang dash state.
// Anything else
// Reconsume in the comment state.

// 13.2.5.48 Comment less-than sign bang dash state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Switch to the comment less-than sign bang dash dash state.
// Anything else
// Reconsume in the comment end dash state.

// 13.2.5.49 Comment less-than sign bang dash dash state
// Consume the next input character:
// U+003E GREATER-THAN SIGN (>)
// EOF
// Reconsume in the comment end state.
// Anything else
// This is a nested-comment parse error. Reconsume in the comment end state.

// 13.2.5.52 Comment end bang state
// Consume the next input character:
// U+002D HYPHEN-MINUS (-)
// Append two U+002D HYPHEN-MINUS characters (-) and a U+0021 EXCLAMATION MARK character (!) to the comment token's data. Switch to the comment end dash state.
// U+003E GREATER-THAN SIGN (>)
// This is an incorrectly-closed-comment parse error. Switch to the data state. Emit the current comment token.
// EOF
// This is an eof-in-comment parse error. Emit the current comment token. Emit an end-of-file token.
// Anything else
// Append two U+002D HYPHEN-MINUS characters (-) and a U+0021 EXCLAMATION MARK character (!) to the comment token's data. Reconsume in the comment state.

// 13.2.5.56 After DOCTYPE name state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// If the six characters starting from the current input character are an ASCII case-insensitive match for the word "PUBLIC", then consume those characters and switch to the after DOCTYPE public keyword state.
// Otherwise, if the six characters starting from the current input character are an ASCII case-insensitive match for the word "SYSTEM", then consume those characters and switch to the after DOCTYPE system keyword state.
// Otherwise, this is an invalid-character-sequence-after-doctype-name parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.57 After DOCTYPE public keyword state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Switch to the before DOCTYPE public identifier state.
// U+0022 QUOTATION MARK (")
// This is a missing-whitespace-after-doctype-public-keyword parse error. Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// This is a missing-whitespace-after-doctype-public-keyword parse error. Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (single-quoted) state.
// U+003E GREATER-THAN SIGN (>)
// This is a missing-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.58 Before DOCTYPE public identifier state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+0022 QUOTATION MARK (")
// Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// Set the current DOCTYPE token's public identifier to the empty string (not missing), then switch to the DOCTYPE public identifier (single-quoted) state.
// U+003E GREATER-THAN SIGN (>)
// This is a missing-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.59 DOCTYPE public identifier (double-quoted) state
// Consume the next input character:
// U+0022 QUOTATION MARK (")
// Switch to the after DOCTYPE public identifier state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's public identifier.
// U+003E GREATER-THAN SIGN (>)
// This is an abrupt-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// Append the current input character to the current DOCTYPE token's public identifier.

// 13.2.5.60 DOCTYPE public identifier (single-quoted) state
// Consume the next input character:
// U+0027 APOSTROPHE (')
// Switch to the after DOCTYPE public identifier state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's public identifier.
// U+003E GREATER-THAN SIGN (>)
// This is an abrupt-doctype-public-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// Append the current input character to the current DOCTYPE token's public identifier.

// 13.2.5.61 After DOCTYPE public identifier state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Switch to the between DOCTYPE public and system identifiers state.
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the current DOCTYPE token.
// U+0022 QUOTATION MARK (")
// This is a missing-whitespace-between-doctype-public-and-system-identifiers parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// This is a missing-whitespace-between-doctype-public-and-system-identifiers parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.62 Between DOCTYPE public and system identifiers state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the current DOCTYPE token.
// U+0022 QUOTATION MARK (")
// Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.63 After DOCTYPE system keyword state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Switch to the before DOCTYPE system identifier state.
// U+0022 QUOTATION MARK (")
// This is a missing-whitespace-after-doctype-system-keyword parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// This is a missing-whitespace-after-doctype-system-keyword parse error. Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
// U+003E GREATER-THAN SIGN (>)
// This is a missing-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.64 Before DOCTYPE system identifier state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+0022 QUOTATION MARK (")
// Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (double-quoted) state.
// U+0027 APOSTROPHE (')
// Set the current DOCTYPE token's system identifier to the empty string (not missing), then switch to the DOCTYPE system identifier (single-quoted) state.
// U+003E GREATER-THAN SIGN (>)
// This is a missing-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is a missing-quote-before-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Reconsume in the bogus DOCTYPE state.

// 13.2.5.65 DOCTYPE system identifier (double-quoted) state
// Consume the next input character:
// U+0022 QUOTATION MARK (")
// Switch to the after DOCTYPE system identifier state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's system identifier.
// U+003E GREATER-THAN SIGN (>)
// This is an abrupt-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// Append the current input character to the current DOCTYPE token's system identifier.

// 13.2.5.66 DOCTYPE system identifier (single-quoted) state
// Consume the next input character:
// U+0027 APOSTROPHE (')
// Switch to the after DOCTYPE system identifier state.
// U+0000 NULL
// This is an unexpected-null-character parse error. Append a U+FFFD REPLACEMENT CHARACTER character to the current DOCTYPE token's system identifier.
// U+003E GREATER-THAN SIGN (>)
// This is an abrupt-doctype-system-identifier parse error. Set the current DOCTYPE token's force-quirks flag to on. Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// Append the current input character to the current DOCTYPE token's system identifier.

// 13.2.5.67 After DOCTYPE system identifier state
// Consume the next input character:
// U+0009 CHARACTER TABULATION (tab)
// U+000A LINE FEED (LF)
// U+000C FORM FEED (FF)
// U+0020 SPACE
// Ignore the character.
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the current DOCTYPE token.
// EOF
// This is an eof-in-doctype parse error. Set the current DOCTYPE token's force-quirks flag to on. Emit the current DOCTYPE token. Emit an end-of-file token.
// Anything else
// This is an unexpected-character-after-doctype-system-identifier parse error. Reconsume in the bogus DOCTYPE state. (This does not set the current DOCTYPE token's force-quirks flag to on.)

// 13.2.5.68 Bogus DOCTYPE state
// Consume the next input character:
// U+003E GREATER-THAN SIGN (>)
// Switch to the data state. Emit the DOCTYPE token.
// U+0000 NULL
// This is an unexpected-null-character parse error. Ignore the character.
// EOF
// Emit the DOCTYPE token. Emit an end-of-file token.
// Anything else
// Ignore the character.

// 13.2.5.69 CDATA section state
// Consume the next input character:
// U+005D RIGHT SQUARE BRACKET (])
// Switch to the CDATA section bracket state.
// EOF
// This is an eof-in-cdata parse error. Emit an end-of-file token.
// Anything else
// Emit the current input character as a character token.
// U+0000 NULL characters are handled in the tree construction stage, as part of the in foreign content insertion mode, which is the only place where CDATA sections can appear.

// 13.2.5.70 CDATA section bracket state
// Consume the next input character:
// U+005D RIGHT SQUARE BRACKET (])
// Switch to the CDATA section end state.
// Anything else
// Emit a U+005D RIGHT SQUARE BRACKET character token. Reconsume in the CDATA section state.

// 13.2.5.71 CDATA section end state
// Consume the next input character:
// U+005D RIGHT SQUARE BRACKET (])
// Emit a U+005D RIGHT SQUARE BRACKET character token.
// U+003E GREATER-THAN SIGN character
// Switch to the data state.
// Anything else
// Emit two U+005D RIGHT SQUARE BRACKET character tokens. Reconsume in the CDATA section state.

// 13.2.5.73 Named character reference state
// Consume the maximum number of characters possible, where the consumed characters are one of the identifiers in the first column of the named character references table. Append each character to the temporary buffer when it's consumed.
// If there is a match
// If the character reference was consumed as part of an attribute, and the last character matched is not a U+003B SEMICOLON character (;), and the next input character is either a U+003D EQUALS SIGN character (=) or an ASCII alphanumeric, then, for historical reasons, flush code points consumed as a character reference and switch to the return state.
// Otherwise:
// If the last character matched is not a U+003B SEMICOLON character (;), then this is a missing-semicolon-after-character-reference parse error.
// Set the temporary buffer to the empty string. Append one or two characters corresponding to the character reference name (as given by the second column of the named character references table) to the temporary buffer.
// Flush code points consumed as a character reference. Switch to the return state.
// Otherwise
// Flush code points consumed as a character reference. Switch to the ambiguous ampersand state.
// If the markup contains (not in an attribute) the string I'm &notit; I tell you, the character reference is parsed as "not", as in, I'm ¬it; I tell you (and this is a parse error). But if the markup was I'm &notin; I tell you, the character reference would be parsed as "notin;", resulting in I'm ∉ I tell you (and no parse error).
// However, if the markup contains the string I'm &notit; I tell you in an attribute, no character reference is parsed and string remains intact (and there is no parse error).

// 13.2.5.74 Ambiguous ampersand state
// Consume the next input character:
// ASCII alphanumeric
// If the character reference was consumed as part of an attribute, then append the current input character to the current attribute's value. Otherwise, emit the current input character as a character token.
// U+003B SEMICOLON (;)
// This is an unknown-named-character-reference parse error. Reconsume in the return state.
// Anything else
// Reconsume in the return state.

// 13.2.5.75 Numeric character reference state
// Set the character reference code to zero (0).
// Consume the next input character:
// U+0078 LATIN SMALL LETTER X
// U+0058 LATIN CAPITAL LETTER X
// Append the current input character to the temporary buffer. Switch to the hexadecimal character reference start state.
// Anything else
// Reconsume in the decimal character reference start state.

// 13.2.5.76 Hexadecimal character reference start state
// Consume the next input character:
// ASCII hex digit
// Reconsume in the hexadecimal character reference state.
// Anything else
// This is an absence-of-digits-in-numeric-character-reference parse error. Flush code points consumed as a character reference. Reconsume in the return state.

// 13.2.5.77 Decimal character reference start state
// Consume the next input character:
// ASCII digit
// Reconsume in the decimal character reference state.
// Anything else
// This is an absence-of-digits-in-numeric-character-reference parse error. Flush code points consumed as a character reference. Reconsume in the return state.

// 13.2.5.78 Hexadecimal character reference state
// Consume the next input character:

// ASCII digit
// Multiply the character reference code by 16. Add a numeric version of the current input character (subtract 0x0030 from the character's code point) to the character reference code.
// ASCII upper hex digit
// Multiply the character reference code by 16. Add a numeric version of the current input character as a hexadecimal digit (subtract 0x0037 from the character's code point) to the character reference code.
// ASCII lower hex digit
// Multiply the character reference code by 16. Add a numeric version of the current input character as a hexadecimal digit (subtract 0x0057 from the character's code point) to the character reference code.
// U+003B SEMICOLON
// Switch to the numeric character reference end state.
// Anything else
// This is a missing-semicolon-after-character-reference parse error. Reconsume in the numeric character reference end state.

// 13.2.5.79 Decimal character reference state
// Consume the next input character:
// ASCII digit
// Multiply the character reference code by 10. Add a numeric version of the current input character (subtract 0x0030 from the character's code point) to the character reference code.
// U+003B SEMICOLON
// Switch to the numeric character reference end state.
// Anything else
// This is a missing-semicolon-after-character-reference parse error. Reconsume in the numeric character reference end state.

// 13.2.5.80 Numeric character reference end state
// Check the character reference code:
// If the number is 0x00, then this is a null-character-reference parse error. Set the character reference code to 0xFFFD.
// If the number is greater than 0x10FFFF, then this is a character-reference-outside-unicode-range parse error. Set the character reference code to 0xFFFD.
// If the number is a surrogate, then this is a surrogate-character-reference parse error. Set the character reference code to 0xFFFD.
// If the number is a noncharacter, then this is a noncharacter-character-reference parse error.
// If the number is 0x0D, or a control that's not ASCII whitespace, then this is a control-character-reference parse error. If the number is one of the numbers in the first column of the following table, then find the row with that number in the first column, and set the character reference code to the number in the second column of that row.
// Number	Code point
// 0x80	0x20AC	EURO SIGN (€)
// 0x82	0x201A	SINGLE LOW-9 QUOTATION MARK (‚)
// 0x83	0x0192	LATIN SMALL LETTER F WITH HOOK (ƒ)
// 0x84	0x201E	DOUBLE LOW-9 QUOTATION MARK („)
// 0x85	0x2026	HORIZONTAL ELLIPSIS (…)
// 0x86	0x2020	DAGGER (†)
// 0x87	0x2021	DOUBLE DAGGER (‡)
// 0x88	0x02C6	MODIFIER LETTER CIRCUMFLEX ACCENT (ˆ)
// 0x89	0x2030	PER MILLE SIGN (‰)
// 0x8A	0x0160	LATIN CAPITAL LETTER S WITH CARON (Š)
// 0x8B	0x2039	SINGLE LEFT-POINTING ANGLE QUOTATION MARK (‹)
// 0x8C	0x0152	LATIN CAPITAL LIGATURE OE (Œ)
// 0x8E	0x017D	LATIN CAPITAL LETTER Z WITH CARON (Ž)
// 0x91	0x2018	LEFT SINGLE QUOTATION MARK (‘)
// 0x92	0x2019	RIGHT SINGLE QUOTATION MARK (’)
// 0x93	0x201C	LEFT DOUBLE QUOTATION MARK (“)
// 0x94	0x201D	RIGHT DOUBLE QUOTATION MARK (”)
// 0x95	0x2022	BULLET (•)
// 0x96	0x2013	EN DASH (–)
// 0x97	0x2014	EM DASH (—)
// 0x98	0x02DC	SMALL TILDE (˜)
// 0x99	0x2122	TRADE MARK SIGN (™)
// 0x9A	0x0161	LATIN SMALL LETTER S WITH CARON (š)
// 0x9B	0x203A	SINGLE RIGHT-POINTING ANGLE QUOTATION MARK (›)
// 0x9C	0x0153	LATIN SMALL LIGATURE OE (œ)
// 0x9E	0x017E	LATIN SMALL LETTER Z WITH CARON (ž)
// 0x9F	0x0178	LATIN CAPITAL LETTER Y WITH DIAERESIS (Ÿ)
// Set the temporary buffer to the empty string. Append a code point equal to the character reference code to the temporary buffer. Flush code points consumed as a character reference. Switch to the return state.
