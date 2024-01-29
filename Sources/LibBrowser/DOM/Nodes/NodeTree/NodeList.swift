extension DOM {
    class LiveNodeList<T: Node>: Sequence {
        var root: Node?

        private func collection() -> [T] {
            // Returns the list of nodes.
            var array: [T] = []
            if let firstChild = root?.firstChild {
                var node: Node? = firstChild
                array.append(node as! T)
                while let nextSibling = node?.nextSibling {
                    node = nextSibling
                    array.append(node as! T)
                }
            }
            return array
        }

        // readonly attribute unsigned long length;
        var length: UInt {
            // Returns the number of nodes in the collection.
            UInt(collection().count)
        }

        subscript(index: UInt) -> T? {
            // Returns the specific node at the given zero-based index into the list.
            item(index: index)
        }

        // getter Node? item(unsigned long index);
        func item(index: UInt) -> T? {
            // The item(index) method must return the indexth
            // node in the collection. If there is no indexth node in the
            // collection, then the method must return null.
            let array = collection()
            guard index < array.count else {
                return nil
            }
            return array[Int(index)]
        }

        // iterable<Node>;
        func makeIterator() -> Array<T>.Iterator {
            collection().makeIterator()
        }
    }
}
