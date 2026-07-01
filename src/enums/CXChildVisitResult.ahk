#Requires AutoHotkey v2.1-alpha.30+

/**
 * Describes how the traversal of the children of a particular cursor should proceed after visiting a particular
 * child cursor. A visitor passed to `CXCursor.Visit` returns one of these values.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__TRAVERSAL.html
 */
export default struct CXChildVisitResult {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /** Terminates the cursor traversal. */
    static Break => 0
    /** Continues the cursor traversal with the next sibling, without visiting the children. */
    static Continue => 1
    /** Recursively traverses the children of this cursor, then continues with the next sibling. */
    static Recurse => 2
}
