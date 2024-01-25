extension DOM {
    // [Exposed=Window]
    // interface ProcessingInstruction : CharacterData {
    //   readonly attribute DOM.String target;
    // };

    class ProcessingInstruction: CharacterData {
        let target: String

        init(target: String, data _: String) {
            self.target = target
            super.init()
        }
    }
}
