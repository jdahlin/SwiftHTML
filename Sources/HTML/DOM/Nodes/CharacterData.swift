// [Exposed=Window]
// interface CharacterData : Node {
//   attribute [LegacyNullToEmptyString] DOMString data;
//   readonly attribute unsigned long length;
//   DOMString substringData(unsigned long offset, unsigned long count);
//   undefined appendData(DOMString data);
//   undefined insertData(unsigned long offset, DOMString data);
//   undefined deleteData(unsigned long offset, unsigned long count);
//   undefined replaceData(unsigned long offset, unsigned long count, DOMString data);
// };

public class CharacterData: Node {
    var data: DOMString = ""
}
