// https://dom.spec.whatwg.org/#interface-domtokenlist

// [Exposed=Window]
// interface DOMTokenList {

//   getter DOM.String? item(unsigned long index);
//   [CEReactions] undefined add(DOM.String... tokens);
//   [CEReactions] undefined remove(DOM.String... tokens);
//   [CEReactions] boolean toggle(DOM.String token, optional boolean force);
//   [CEReactions] boolean replace(DOM.String token, DOM.String newToken);
//   boolean supports(DOM.String token);
//   ;
//   iterable<DOM.String>;
// };

import Collections

extension DOM {
    class TokenList {
        var tokenSet: OrderedSet<String.SubSequence> = []
        var element: DOM.Element
        var localName: DOM.String

        // [CEReactions] stringifier attribute DOM.String value
        var value: DOM.String

        // readonly attribute unsigned long length;
        var length: UInt { UInt(tokenSet.count) }

        init(element: DOM.Element, attribute: DOM.Attr) {
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

        // boolean contains(DOM.String token);
        func contains(_ token: DOM.String) -> Bool {
            tokenSet.contains(String.SubSequence(token))
        }
    }
}
