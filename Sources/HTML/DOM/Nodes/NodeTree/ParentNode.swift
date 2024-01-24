// interface mixin ParentNode {
//   [SameObject] readonly attribute HTMLCollection children;
//   readonly attribute Element? firstElementChild;
//   readonly attribute Element? lastElementChild;
//   readonly attribute unsigned long childElementCount;

//   [CEReactions, Unscopable] undefined prepend((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined append((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined replaceChildren((Node or DOMString)... nodes);
// };
// Document includes ParentNode;
// DocumentFragment includes ParentNode;
// Element includes ParentNode;

public extension Element {
    // Element? querySelector(DOMString selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselector
    func querySelector(_ selectors: DOMString) -> Element? {
        // The querySelector(selectors) method steps are to return the first
        // result of running scope-match a selectors string selectors against
        // this, if the result is not an empty list; otherwise null.
        let result = scopeMatchSelectorsString(selectors: selectors, node: self)
        if result.isEmpty {
            return nil
        }
        return result.first
    }

    // [NewObject] NodeList querySelectorAll(DOMString selectors);
    // https://dom.spec.whatwg.org/#dom-parentnode-queryselectorall
    func querySelectorAll(_ selectors: DOMString) -> [Element] {
        // The querySelectorAll(selectors) method steps are to return the static
        // result of running scope-match a selectors string selectors against
        // this.
        FIXME("Return a NodeList instead of [Element]")
        return scopeMatchSelectorsString(selectors: selectors, node: self)
    }
}

import CSS

struct Selector {
    var selectors: [CSS.ComplexSelector] = []

    init(source: String) {
        // FIXME: parse selector from string
        let result = Result { try CSS.parseAStylesheet(source + " {}") }
        switch result {
        case let .success(parsed):
            assert(parsed.rules.count == 1)
            // FIXME: parse qualifiedRules.prelude -> list of selectors
            if case let .qualified(qualifiedRule) = parsed.rules[0] {
                selectors = CSS.consumeSelectorList(qualifiedRule.prelude)
            }

        case let .failure(error):
            print(error)
        }
    }

    func matchCompoundSelector(compound: CSS.CompoundSelector, element: Element) -> Bool {
        if compound.typeSelector != nil {
            let typeSelector = compound.typeSelector!
            assert(typeSelector.nsPrefix == nil)
            if typeSelector.name != nil,
               typeSelector.name == "*" || element.localName == typeSelector.name
            {
                return true
            }
        }
        if compound.subclassSelectors != nil {
            for subclassSelector in compound.subclassSelectors {
                switch subclassSelector {
                case .id("*"):
                    return true
                case let .id(id):
                    if element.id == id {
                        return true
                    }
                case let .class_(className):
                    if element.classList.contains(className) {
                        return true
                    }
                case let .attribute(attribute):
                    FIXME("attribute selectors not implemented")
                case .psuedo:
                    FIXME("psuedo selectors not implemented")
                }
            }
        }
        if compound.pseudoSelectors.count > 0 {
            FIXME("compound psuedo selectors not implemented")
        }
        return false
    }

    func matchComplexSelector(complex: CSS.ComplexSelector, element: Element) -> Bool {
        if matchCompoundSelector(compound: complex.compound, element: element) {
            return true
        }
        if complex.elements.count > 0 {
            FIXME("complex elements not implemented")
        }
        return false
    }

    func match(element: Element) -> Bool {
        for complex in selectors.reversed() {
            if matchComplexSelector(complex: complex, element: element) {
                return true
            }
        }
        return false
    }
}

// https://drafts.csswg.org/selectors-4/#parse-selector
func parseSelector(source: String) -> Result<Selector, Error> {
    let selector = Selector(source: source)
    return .success(selector)
}

func getDescendants(element: Element) -> [Element] {
    var descendants: [Element] = []
    if element.firstChild != nil {
        var node = element.firstChild
        repeat {
            node = node?.nextSibling
            if node is Element {
                descendants.append(node as! Element)
            }
        } while node?.nextSibling != nil
    }
    return descendants
}

func isDescendantOf(element: Element, ancestor: Element) -> Bool {
    var node = element.parentNode
    while node != nil {
        if node == ancestor {
            return true
        }
        node = node?.parentNode
    }
    return false
}

// match a selector against a tree
// https://drafts.csswg.org/selectors-4/#match-against-tree
func matchSelectorAgainstTree(selector: Selector,
                              rootElements: [Element],
                              scopingRoots: [Element] = [],
                              pseudoElements _: [Element] = []) -> [Element]
{
    // 1. Start with a list of candidate elements, which are the root elements
    //    and all of their descendant elements, sorted in shadow-including tree
    //    order, unless otherwise specified.
    var candidateElements: [Element] = []
    for rootElement in rootElements {
        candidateElements.append(rootElement)
        candidateElements.append(contentsOf: getDescendants(element: rootElement))
    }

    // 2. If scoping root were provided, then remove from the candidate elements
    //    any elements that are not descendants of at least one scoping root.
    if !scopingRoots.isEmpty {
        candidateElements = candidateElements.filter { e in
            for root in scopingRoots {
                if isDescendantOf(element: e, ancestor: root) {
                    return true
                }
            }
            return false
        }
    }

    // 3. Initialize the selector match list to empty.
    var selectorMatchList: [Element] = []

    // 4. For each element in the set of candidate elements:
    for candidateElement in candidateElements {
        // 4.1. If the result of match a selector against an element for element and
        //    selector is success, add element to the selector match list.
        if selector.match(element: candidateElement) {
            selectorMatchList.append(candidateElement)
        }

        // 4.2. For each possible pseudo-element associated with element that is one
        //    of the pseudo-elements allowed to show up in the match list, if the
        //    result of match a selector against a pseudo-element for the
        //    pseudo-element and selector is success, add the pseudo-element to the
        //    selector match list.
    }
    return selectorMatchList
}

// https://dom.spec.whatwg.org/#scope-match-a-selectors-string
func scopeMatchSelectorsString(selectors: DOMString, node: Node) -> [Element] {
    // 1. Let s be the result of parse a selector selectors. [SELECTORS4]
    let s = parseSelector(source: selectors)
    switch s {
    // 2. If s is failure, then throw a "SyntaxError" DOMException.
    case let .failure(error):
        fatalError("\(error)")

    // 3. Return the result of match a selector against a tree with s and node’s
    //    root using scoping root node. [SELECTORS4].
    case let .success(selector):
        return matchSelectorAgainstTree(
            selector: selector,
            rootElements: [node as! Element],
            scopingRoots: [node as! Element]
        )
    }
}

// https://dom.spec.whatwg.org/#converting-nodes-into-a-node
func convertNodesIntoNode(nodes: [NodeOrString], document: Document) -> Node {
    // 1. Let node be null.
    var node: Node? = nil

    // 2. Replace each string in nodes with a new Text node whose data is the
    //    string and node document is document.
    let convertedNodes: [Node] = nodes.map { nodeOrString -> Node in
        switch nodeOrString {
        case let .node(node):
            return node
        case let .string(string):
            return Text(data: string, ownerDocument: document)
        }
    }

    // 3. If nodes contains one node, then set node to nodes[0].
    if convertedNodes.count == 1 {
        node = convertedNodes[0]
    }
    // 4. Otherwise, set node to a new DocumentFragment node whose node document
    //    is document, and then append each node in nodes, if any, to it.
    else {
        node = DocumentFragment(ownerDocument: document)
        for convertedNode in convertedNodes {
            node!.appendChild(node: convertedNode)
        }
    }

    // 5. Return node.
    return node!
}
