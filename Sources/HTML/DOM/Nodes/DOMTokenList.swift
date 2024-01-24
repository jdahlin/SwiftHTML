// https://dom.spec.whatwg.org/#interface-domtokenlist

// [Exposed=Window]
// interface DOMTokenList {

//   getter DOMString? item(unsigned long index);
//   [CEReactions] undefined add(DOMString... tokens);
//   [CEReactions] undefined remove(DOMString... tokens);
//   [CEReactions] boolean toggle(DOMString token, optional boolean force);
//   [CEReactions] boolean replace(DOMString token, DOMString newToken);
//   boolean supports(DOMString token);
//   ;
//   iterable<DOMString>;
// };

import Collections

class DOMTokenList {
    var tokenSet: OrderedSet<String.SubSequence> = []
    var element: Element
    var localName: DOMString

    // [CEReactions] stringifier attribute DOMString value
    var value: DOMString

    // readonly attribute unsigned long length;
    var length: UInt { UInt(tokenSet.count) }

    init(element: Element, attribute: Attr) {
        // 1. Let element be associated element.
        self.element = element

        // 2. Let localName be associated attribute’s local name.
        localName = attribute.localName

        // 3. Let value be the result of getting an attribute value given
        //    element and localName.
        value = attribute.value

        // FIXME: 4. Run the attribute change steps for element, localName,
        //           value, value, and null.

        tokenSet = orderedSetParser(input: value)
    }

    // boolean contains(DOMString token);
    func contains(_ token: DOMString) -> Bool {
        return tokenSet.contains(String.SubSequence(token))
    }
}
