// [Exposed=Window]
// interface NodeList {
//   getter Node? item(unsigned long index);
//   readonly attribute unsigned long length;
//   iterable<Node>;
// };

class NodeList<T: Node>: Sequence {
    var array: Array<T>
    
    init(array: Array<T> = []) {
        self.array = array
    }
    
    func makeIterator() -> Array<T>.Iterator {
        return array.makeIterator()
    }
}
