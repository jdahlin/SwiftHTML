extension DOM {
    // [Exposed=Window]
    // interface DocumentType : Node {
    //   readonly attribute DOM.String name;
    //   readonly attribute DOM.String publicId;
    //   readonly attribute DOM.String systemId;
    // };
    class DocumentType: Node {
        let name: DOM.String
        let publicId: DOM.String?
        let systemId: DOM.String?

        init(name: DOM.String, publicId: DOM.String?, systemId: DOM.String?) {
            self.name = name
            self.publicId = publicId
            self.systemId = systemId
            super.init()
        }
    }
}
