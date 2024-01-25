// [Exposed=Window]
// interface CharacterData : Node {
//   attribute [LegacyNullToEmptyString] DOM.String data;
//   readonly attribute unsigned long length;
//   DOM.String substringData(unsigned long offset, unsigned long count);
//   undefined appendData(DOM.String data);
//   undefined insertData(unsigned long offset, DOM.String data);
//   undefined deleteData(unsigned long offset, unsigned long count);
//   undefined replaceData(unsigned long offset, unsigned long count, DOM.String data);
// };

public extension DOM {
    class CharacterData: Node {
        var data: DOM.String = ""
    }
}
