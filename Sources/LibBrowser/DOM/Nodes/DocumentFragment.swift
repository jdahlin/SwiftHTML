extension DOM {
    // [Exposed=Window]
    // interface DocumentFragment : Node {
    //   constructor();
    // };

    public class DocumentFragment: Node {}

    // https://dom.spec.whatwg.org/#concept-tree-host-including-inclusive-ancestor
    static func isHostIncludingInclusiveAncestor(a: Node, b: Node) -> Bool {
        // An object A is a host-including inclusive ancestor of an object B, if either
        // A is an inclusive ancestor of B, or if B’s root has a non-null host and A is
        // a host-including inclusive ancestor of B’s root’s host.

        if isInclusiveAncestor(node: a, ancestor: b) {
            return true
        }

        // if let bRoot = rootOf(node: b), let bRootHost: Node? = nil {
        //     return isHostIncludingInclusiveAncestor(a: a, b: bRootHost)
        // }

        return false
    }
}
