// [Exposed=*,
//  Serializable]
// interface DOMException { // but see below note about JavaScript binding
//   constructor(optional DOM.String message = "", optional DOM.String name = "Error");
//   readonly attribute DOM.String name;
//   readonly attribute DOM.String message;
//   readonly attribute unsigned short code;

//   const unsigned short INDEX_SIZE_ERR = 1;
//   const unsigned short DOM.String_SIZE_ERR = 2;
//   const unsigned short HIERARCHY_REQUEST_ERR = 3;
//   const unsigned short WRONG_DOCUMENT_ERR = 4;
//   const unsigned short INVALID_CHARACTER_ERR = 5;
//   const unsigned short NO_DATA_ALLOWED_ERR = 6;
//   const unsigned short NO_MODIFICATION_ALLOWED_ERR = 7;
//   const unsigned short NOT_FOUND_ERR = 8;
//   const unsigned short NOT_SUPPORTED_ERR = 9;
//   const unsigned short INUSE_ATTRIBUTE_ERR = 10;
//   const unsigned short INVALID_STATE_ERR = 11;
//   const unsigned short SYNTAX_ERR = 12;
//   const unsigned short INVALID_MODIFICATION_ERR = 13;
//   const unsigned short NAMESPACE_ERR = 14;
//   const unsigned short INVALID_ACCESS_ERR = 15;
//   const unsigned short VALIDATION_ERR = 16;
//   const unsigned short TYPE_MISMATCH_ERR = 17;
//   const unsigned short SECURITY_ERR = 18;
//   const unsigned short NETWORK_ERR = 19;
//   const unsigned short ABORT_ERR = 20;
//   const unsigned short URL_MISMATCH_ERR = 21;
//   const unsigned short QUOTA_EXCEEDED_ERR = 22;
//   const unsigned short TIMEOUT_ERR = 23;
//   const unsigned short INVALID_NODE_TYPE_ERR = 24;
//   const unsigned short DATA_CLONE_ERR = 25;
// };
enum DOMException: Error {
    case indexError
    case domStringError
    case hierarchyRequestError
    case wrongDocumentError
    case invalidCharacterError
    case noDataAllowedError
    case noModificationAllowedError
    case notFoundError
    case notSupportedError
    case inuseAttributeError
    case invalidStateError
    case syntaxError
    case invalidModificationError
    case namespaceError
    case invalidAccessError
    case validationError
    case typeMismatchError
    case securityError
    case networkError
    case abortError
    case urlMismatchError
    case quotaExceededError
    case timeoutError
    case invalidNodeTypeError
    case dataCloneError
}
