// [Exposed=Window]
// interface DocumentType : Node {
//   readonly attribute DOMString name;
//   readonly attribute DOMString publicId;
//   readonly attribute DOMString systemId;
// };
class DocumentType: Node {
    let name: DOMString
    let publicId: DOMString?
    let systemId: DOMString?

    init(name: DOMString, publicId: DOMString?, systemId: DOMString?) {
        self.name = name
        self.publicId = publicId
        self.systemId = systemId
        super.init()
    }
}
