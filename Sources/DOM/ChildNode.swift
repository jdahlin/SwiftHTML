// interface mixin ChildNode {
//   [CEReactions, Unscopable] undefined before((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined after((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined replaceWith((Node or DOMString)... nodes);
//   [CEReactions, Unscopable] undefined remove();
// };

// DocumentType includes ChildNode;

protocol ChildNode {
    func before(_ nodes: Node...)
    func before(_ nodes: DOMString...)
    func after(_ nodes: Node...)
    func after(_ nodes: DOMString...)
    func replaceWith(_ nodes: Node...)
    func replaceWith(_ nodes: DOMString...)
    func remove()
}

// Element includes ChildNode;
extension Element: ChildNode {
    func before(_: Node...) {
        print("\(#function): not implemented")
    }

    func before(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func after(_ nodes: Node...) {
        // Inserts nodes just after node, while replacing strings in nodes with
        // equivalent Text nodes.
        for child in nodes {
            if let parent = parentNode {
                let index = parent.childNodes.array.firstIndex(of: self)
                parent.childNodes.array.insert(child, at: index! + 1)
                child.parentNode = parent
            }
        }
    }

    func after(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func replaceWith(_: Node...) {
        print("\(#function): not implemented")
    }

    func replaceWith(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func remove() {
        print("\(#function): not implemented")
    }
}

// CharacterData includes ChildNode;
extension CharacterData: ChildNode {
    func before(_: Node...) {
        print("\(#function): not implemented")
    }

    func before(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func after(_ nodes: Node...) {
        // Inserts nodes just after node, while replacing strings in nodes with
        // equivalent Text nodes.
        for child in nodes {
            if let parent = parentNode {
                let index = parent.childNodes.array.firstIndex(of: self)
                parent.childNodes.array.insert(child, at: index! + 1)
                child.parentNode = parent
            }
        }
    }

    func after(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func replaceWith(_: Node...) {
        print("\(#function): not implemented")
    }

    func replaceWith(_: DOMString...) {
        print("\(#function): not implemented")
    }

    func remove() {
        print("\(#function): not implemented")
    }
}
