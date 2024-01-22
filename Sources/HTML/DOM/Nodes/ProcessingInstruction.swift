// [Exposed=Window]
// interface ProcessingInstruction : CharacterData {
//   readonly attribute DOMString target;
// };

public class ProcessingInstruction: CharacterData {
    let target: String

    init(target: String, data _: String) {
        self.target = target
        super.init()
    }
}
