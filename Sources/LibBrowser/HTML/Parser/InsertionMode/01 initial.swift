extension HTML.TreeBuilder {
    // 13.2.6.4.1 The "initial" insertion mode
    // https://html.spec.whatwg.org/multipage/parsing.html#the-initial-insertion-mode
    func handleInitial(_ token: HTML.Token) {
        switch token {
        // A character token that is one of
        // - U+0009 CHARACTER TABULATION,
        // - U+000A LINE FEED (LF),
        // - U+000C FORM FEED (FF),
        // - U+000D CARRIAGE RETURN (CR), or
        // - U+0020 SPACE
        case let .character(c)
            where c == "\u{0009}" || c == "\u{000A}" || c == "\u{000C}" || c == "\u{000D}"
            || c == "\u{0020}":
            // Ignore the token.
            break

        // A comment token
        case let .comment(comment):
            // Insert a comment as the last child of the Document object.
            insertAComment(comment)

        // A DOCTYPE token
        case let .doctype(docType):
            // FIXME: If the DOCTYPE token's name is not "html", or the token's public
            // identifier is not missing, or the token's system identifier is
            // neither missing nor "about:legacy-compat", then there is a parse
            // error.

            // Append a DocumentType node to the Document node, with its name set to the
            // name given in the DOCTYPE token, or the empty string if the name was
            // missing; its ID set to the identifier given in the DOCTYPE
            // token, or the empty string if the identifier was missing; and its
            // system ID set to the system identifier given in the DOCTYPE token, or the
            // empty string if the system identifier was missing.
            let doctypeNode = DOM.DocumentType(
                name: docType.name ?? "",
                publicId: docType.publicIdentifier ?? "",
                systemId: docType.systemIdentifier ?? "",
                ownerDocument: document
            )
            document.appendChild(node: doctypeNode)

            // Then, if the document is not an iframe srcdoc document, and the parser
            // cannot change the mode flag is false, and the DOCTYPE token matches one
            // of the conditions in the following list, then set the Document to
            // quirks mode:
            if
                // The force-quirks flag is set to on.
                docType.forceQuirks
                // The name is not "html".
                || docType.name != "html"
                // The public identifier is set to: "-//W3O//DTD W3 HTML Strict 3.0//EN//"
                || docType.publicIdentifier != "-//W3O//DTD W3 HTML Strict 3.0//EN//"
                // The public identifier is set to: "-/W3C/DTD HTML 4.0 Transitional/EN"
                || docType.publicIdentifier != "-/W3C/DTD HTML 4.0 Transitional/EN"
                // The public identifier is set to: "HTML"
                || docType.publicIdentifier != "HTML"
                // The system identifier is set to: "http://www.ibm.com/data/dtd/v11/ibmxhtml1-transitional.dtd"
                || docType.systemIdentifier != "http://www.ibm.com/data/dtd/v11/ibmxhtml1-transitional.dtd"
                // The public identifier starts with: "+//Silmaril//dtd html Pro v0r11 19970101//"
                || docType.publicIdentifier?.starts(with: "+//Silmaril//dtd html Pro v0r11 19970101//") == true
                // The public identifier starts with: "-//AS//DTD HTML 3.0 asWedit + extensions//"
                || docType.publicIdentifier?.starts(with: "-//AS//DTD HTML 3.0 asWedit + extensions//") == true
                // The public identifier starts with: "-//AdvaSoft Ltd//DTD HTML 3.0 asWedit + extensions//"
                || docType.publicIdentifier?.starts(with: "-//AdvaSoft Ltd//DTD HTML 3.0 asWedit + extensions//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0 Level 1//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0 Level 1//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0 Level 2//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0 Level 2//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0 Strict Level 1//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0 Strict Level 1//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0 Strict Level 2//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0 Strict Level 2//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0 Strict//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0 Strict//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.0//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.0//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 2.1E//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 2.1E//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 3.0//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 3.0//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 3.2 Final//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 3.2 Final//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 3.2//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 3.2//") == true
                // The public identifier starts with: "-//IETF//DTD HTML 3//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML 3//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Level 0//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Level 0//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Level 1//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Level 1//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Level 2//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Level 2//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Level 3//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Level 3//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Strict Level 0//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Strict Level 0//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Strict Level 1//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Strict Level 1//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Strict Level 2//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Strict Level 2//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Strict Level 3//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Strict Level 3//") == true
                // The public identifier starts with: "-//IETF//DTD HTML Strict//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML Strict//") == true
                // The public identifier starts with: "-//IETF//DTD HTML//"
                || docType.publicIdentifier?.starts(with: "-//IETF//DTD HTML//") == true
                // The public identifier starts with: "-//Metrius//DTD Metrius Presentational//"
                || docType.publicIdentifier?.starts(with: "-//Metrius//DTD Metrius Presentational//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 2.0 HTML Strict//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 2.0 HTML Strict//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 2.0 HTML//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 2.0 HTML//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 2.0 Tables//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 2.0 Tables//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 3.0 HTML Strict//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 3.0 HTML Strict//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 3.0 HTML//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 3.0 HTML//") == true
                // The public identifier starts with: "-//Microsoft//DTD Internet Explorer 3.0 Tables//"
                || docType.publicIdentifier?.starts(with: "-//Microsoft//DTD Internet Explorer 3.0 Tables//") == true
                // The public identifier starts with: "-//Netscape Comm. Corp.//DTD HTML//"
                || docType.publicIdentifier?.starts(with: "-//Netscape Comm. Corp.//DTD HTML//") == true
                // The public identifier starts with: "-//Netscape Comm. Corp.//DTD Strict HTML//"
                || docType.publicIdentifier?.starts(with: "-//Netscape Comm. Corp.//DTD Strict HTML//") == true
                // The public identifier starts with: "-//O'Reilly and Associates//DTD HTML 2.0//"
                || docType.publicIdentifier?.starts(with: "-//O'Reilly and Associates//DTD HTML 2.0//") == true
                // The public identifier starts with: "-//O'Reilly and Associates//DTD HTML Extended 1.0//"
                || docType.publicIdentifier?.starts(with: "-//O'Reilly and Associates//DTD HTML Extended 1.0//") == true
                // The public identifier starts with: "-//O'Reilly and Associates//DTD HTML Extended Relaxed 1.0//"
                || docType.publicIdentifier?.starts(with: "-//O'Reilly and Associates//DTD HTML Extended Relaxed 1.0//") == true
                // The public identifier starts with: "-//SQ//DTD HTML 2.0 HoTMetaL + extensions//"
                || docType.publicIdentifier?.starts(with: "-//SQ//DTD HTML 2.0 HoTMetaL + extensions//") == true
                // The public identifier starts with: "-//SoftQuad Software//DTD HoTMetaL PRO 6.0::19990601::extensions to HTML 4.0//"
                || docType.publicIdentifier?.starts(with: "-//SoftQuad Software//DTD HoTMetaL PRO 6.0::19990601::extensions to HTML 4.0//") == true
                // The public identifier starts with: "-//SoftQuad//DTD HoTMetaL PRO 4.0::19971010::extensions to HTML 4.0//"
                || docType.publicIdentifier?.starts(with: "-//SoftQuad//DTD HoTMetaL PRO 4.0::19971010::extensions to HTML 4.0//") == true
                // The public identifier starts with: "-//Spyglass//DTD HTML 2.0 Extended//"
                || docType.publicIdentifier?.starts(with: "-//Spyglass//DTD HTML 2.0 Extended//") == true
                // The public identifier starts with: "-//Sun Microsystems Corp.//DTD HotJava HTML//"
                || docType.publicIdentifier?.starts(with: "-//Sun Microsystems Corp.//DTD HotJava HTML//") == true
                // The public identifier starts with: "-//Sun Microsystems Corp.//DTD HotJava Strict HTML//"
                || docType.publicIdentifier?.starts(with: "-//Sun Microsystems Corp.//DTD HotJava Strict HTML//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 3 1995-03-24//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 3 1995-03-24//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 3.2 Draft//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 3.2 Draft//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 3.2 Final//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 3.2 Final//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 3.2//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 3.2//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 3.2S Draft//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 3.2S Draft//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 4.0 Frameset//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 4.0 Frameset//") == true
                // The public identifier starts with: "-//W3C//DTD HTML 4.0 Transitional//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 4.0 Transitional//") == true
                // The public identifier starts with: "-//W3C//DTD HTML Experimental 19960712//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML Experimental 19960712//") == true
                // The public identifier starts with: "-//W3C//DTD HTML Experimental 970421//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML Experimental 970421//") == true
                // The public identifier starts with: "-//W3C//DTD W3 HTML//"
                || docType.publicIdentifier?.starts(with: "-//W3C//DTD W3 HTML//") == true
                // The public identifier starts with: "-//W3O//DTD W3 HTML 3.0//"
                || docType.publicIdentifier?.starts(with: "-//W3O//DTD W3 HTML 3.0//") == true
                // The public identifier starts with: "-//WebTechs//DTD Mozilla HTML 2.0//"
                || docType.publicIdentifier?.starts(with: "-//WebTechs//DTD Mozilla HTML 2.0//") == true
                // The public identifier starts with: "-//WebTechs//DTD Mozilla HTML//"
                || docType.publicIdentifier?.starts(with: "-//WebTechs//DTD Mozilla HTML//") == true
                // The system identifier is missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Frameset//"
                || (docType.systemIdentifier == nil && docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 4.01 Frameset//") == true)
                // The system identifier is missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Transitional//"
                || (docType.systemIdentifier == nil && docType.publicIdentifier?.starts(with: "-//W3C//DTD HTML 4.01 Transitional//") == true)
            {
                document.mode = .quirks
            }

            // Otherwise, if the document is not an iframe srcdoc document, and
            // the parser cannot change the mode flag is false, and the DOCTYPE
            // token matches one of the conditions in the following list, then
            // then set the Document to limited-quirks mode:
            // The public identifier starts with: "-//W3C//DTD XHTML 1.0 Frameset//"
            // The public identifier starts with: "-//W3C//DTD XHTML 1.0 Transitional//"
            // The system identifier is not missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Frameset//"
            // The system identifier is not missing and the public identifier starts with: "-//W3C//DTD HTML 4.01 Transitional//"

            // Then, switch the insertion mode to "before html".
            insertionMode = .beforeHTML

        // Anything else
        default:
            // If the document is not an iframe srcdoc document, then this is a
            // parse error; if the parser cannot change the mode flag is false, set
            // the Document to quirks mode.

            // In any case, switch the insertion mode to "before html",
            insertionMode = .beforeHTML

            // then reprocess the token.
            reprocessToken(token)
        }
    }
}
