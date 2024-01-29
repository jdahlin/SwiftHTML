extension CSS {
    struct Selector {
        var selectors: [CSS.ComplexSelector] = []

        init(source: String) {
            // FIXME: parse selector from string
            let result = Result { try CSS.parseAStylesheet(data: source + " {}") }
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

        func matchCompoundSelector(compound: CSS.CompoundSelector, element: DOM.Element) -> Bool {
            if let typeSelector = compound.typeSelector {
                assert(typeSelector.nsPrefix == nil)
                if typeSelector.name == "*" || element.localName == typeSelector.name {
                    return true
                }
            }
            for subclassSelector in compound.subclassSelectors {
                switch subclassSelector {
                case let .id(id) where element.id == id:
                    return true
                case let .class_(className) where element.classList.contains(className):
                    return true
                case .attribute:
                    FIXME("attribute selectors not implemented")
                case .psuedo:
                    FIXME("pseudo selectors not implemented")
                default:
                    continue
                }
            }
            if compound.pseudoSelectors.count > 0 {
                FIXME("compound pseudo selectors not implemented")
            }
            return false
        }

        func matchComplexSelector(complex: CSS.ComplexSelector, element: DOM.Element) -> Bool {
            if matchCompoundSelector(compound: complex.compound, element: element) {
                return true
            }
            if complex.elements.count > 0 {
                FIXME("complex elements not implemented")
            }
            return false
        }

        func match(element: DOM.Element) -> Bool {
            for complex in selectors.reversed() {
                if matchComplexSelector(complex: complex, element: element) {
                    return true
                }
            }
            return false
        }
    }

    // https://drafts.csswg.org/selectors-4/#parse-selector
    static func parseSelector(source: String) -> Result<Selector, Error> {
        let selector = Selector(source: source)
        return .success(selector)
    }

    // match a selector against a tree
    // https://drafts.csswg.org/selectors-4/#match-against-tree
    static func matchSelectorAgainstTree(selector: Selector,
                                         rootElements: [DOM.Element],
                                         scopingRoots: [DOM.Element] = [],
                                         pseudoElements: [DOM.Element] = []) -> [DOM.Element]
    {
        // 1. Start with a list of candidate elements, which are the root elements
        //    and all of their descendant elements, sorted in shadow-including tree
        //    order, unless otherwise specified.
        var candidateElements: [DOM.Element] = []
        for rootElement in rootElements {
            candidateElements.append(rootElement)
            candidateElements.append(contentsOf: DOM.getDescendants(element: rootElement))
        }

        // 2. If scoping root were provided, then remove from the candidate elements
        //    any elements that are not descendants of at least one scoping root.
        if !scopingRoots.isEmpty {
            candidateElements = candidateElements.filter { e in
                for root in scopingRoots {
                    if DOM.isDescendantOf(element: e, ancestor: root) {
                        return true
                    }
                }
                return false
            }
        }

        // 3. Initialize the selector match list to empty.
        let selectorMatchList: [DOM.Element] =

            // 4. For each element in the set of candidate elements:
            candidateElements.filter {
                // 4.1. If the result of match a selector against an element for element and
                //      selector is success, add element to the selector match list.
                selector.match(element: $0)
            }

        // 4.2. For each possible pseudo-element associated with element that is one
        //    of the pseudo-elements allowed to show up in the match list, if the
        //    result of match a selector against a pseudo-element for the
        //    pseudo-element and selector is success, add the pseudo-element to the
        //    selector match list.
        if !pseudoElements.isEmpty {
            FIXME("pseudo elements not implemented")
        }

        return selectorMatchList
    }

    // https://dom.spec.whatwg.org/#scope-match-a-selectors-string
    static func scopeMatchSelectorsString(selectors: DOM.String, node: DOM.Node) -> [DOM.Element] {
        // 1. Let s be the result of parse a selector selectors. [SELECTORS4]
        let s = parseSelector(source: selectors)
        switch s {
        // 2. If s is failure, then throw a "SyntaxError" DOMException.
        case let .failure(error):
            fatalError("\(error)")

        // 3. Return the result of match a selector against a tree with s and node’s
        //    root using scoping root node. [SELECTORS4].
        case let .success(selector):
            if let element = node as? DOM.Element {
                return matchSelectorAgainstTree(
                    selector: selector,
                    rootElements: [element],
                    scopingRoots: [element]
                )
            } else {
                fatalError("node: \(node) is not an element")
            }
        }
    }
}
