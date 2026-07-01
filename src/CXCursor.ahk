#Requires AutoHotkey v2.1-alpha.30+

#Import Enums {CursorKind, CXChildVisitResult}
#Import CXType
#Import CXString
#Import CXSourceLocation
#Import CXSourceRange

/**
 * A cursor representing some element in the abstract syntax tree for a translation unit.
 *
 * `CXCursor` is a value type. Its `data` pointers reference the owning translation unit, so a cursor is only valid
 * while that translation unit is alive. A cursor may be freely copied (see `Clone`) and remains valid as long as the
 * translation unit it came from is.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__CURSOR__MANIP.html
 */
export default struct CXCursor {
    /** The kind of entity this cursor refers to. */
    kind: CursorKind
    xdata: Int32
    data: IntPtr[3]

    /**
     * True if this cursor is the null cursor (no entity).
     */
    IsNull => DllCall("libclang\clang_Cursor_isNull", CXCursor, this, "uint") != 0

    /**
     * The spelling of this cursor's kind, e.g. "StructDecl", "FunctionDecl".
     */
    KindSpelling => DllCall("libclang\clang_getCursorKindSpelling", "int", this.kind, CXString).ToString()

    /**
     * The name of the entity referred to, e.g. the identifier of a declaration.
     */
    Spelling => DllCall("libclang\clang_getCursorSpelling", CXCursor, this, CXString).ToString()

    /**
     * A display name, which for functions includes the parameter types.
     */
    DisplayName => DllCall("libclang\clang_getCursorDisplayName", CXCursor, this, CXString).ToString()

    /**
     * The type of this cursor (if any).
     */
    Type => DllCall("libclang\clang_getCursorType", CXCursor, this, CXType)

    /**
     * For a function or method, the return type.
     */
    ResultType => DllCall("libclang\clang_getCursorResultType", CXCursor, this, CXType)

    /**
     * For a typedef declaration, the underlying aliased type.
     */
    UnderlyingType => DllCall("libclang\clang_getTypedefDeclUnderlyingType", CXCursor, this, CXType)

    /**
     * For an enum constant declaration, its integer value.
     */
    EnumConstantValue => DllCall("libclang\clang_getEnumConstantDeclValue", CXCursor, this, "int64")

    /** 
     * For an enum declaration, the integer type used to represent its values.
     */
    EnumIntegerType => DllCall("libclang\clang_getEnumDeclIntegerType", CXCursor, this, CXType)

    /**
     * For a field declared as a bit field, its width in bits; -1 if not a bit field.
     */
    BitWidth => DllCall("libclang\clang_getFieldDeclBitWidth", CXCursor, this, "int")

    /**
     * For a function or method, the number of non-variadic arguments.
     */
    NumArguments => DllCall("libclang\clang_Cursor_getNumArguments", CXCursor, this, "int")

    /**
     * For a function or method, the cursor for argument `i` (0-based), which carries the parameter's name and type.
     */
    Argument(i) => DllCall("libclang\clang_Cursor_getArgument", CXCursor, this, "uint", i, CXCursor)

    /**
     * Determines whether two cursors are equivalent.
     */
    Equals(other) => DllCall("libclang\clang_equalCursors", CXCursor, this, CXCursor, other, "uint") != 0

    /**
     * The physical source location of this cursor (points at the entity's name).
     */
    Location => DllCall("libclang\clang_getCursorLocation", CXCursor, this, CXSourceLocation)

    /**
     * The physical source range occupied by this cursor (its full extent).
     */
    Extent => DllCall("libclang\clang_getCursorExtent", CXCursor, this, CXSourceRange)

    /**
     * Returns an independent copy of this cursor with its own backing memory. Use this to keep a cursor handed to a
     * `Visit` callback (those are transient views over memory owned by libclang for the duration of the call).
     */
    Clone() {
        copy := CXCursor()
        DllCall("RtlMoveMemory", "ptr", copy, "ptr", this, "uptr", copy.Size)
        return copy
    }

    /**
     * Visits the immediate children of this cursor, invoking `visitor` for each.
     *
     * The visitor receives `(cursor, parent)` and must return a `CXChildVisitResult` value (`Break`, `Continue` or
     * `Recurse`). The cursors passed in are transient views valid only for the duration of the call; use `.Clone()`
     * to keep one. If the visitor returns nothing, traversal continues with the next sibling.
     *
     * @param {Func} visitor `(cursor, parent) => CXChildVisitResult`
     * @returns {Integer} Non-zero if traversal was terminated early by a `Break`.
     */
    Visit(visitor) {
        cb := CallbackCreate(_visit, , 3)
        try
            return DllCall("libclang\clang_visitChildren", CXCursor, this, "ptr", cb, "ptr", 0, "uint")
        finally
            CallbackFree(cb)

        _visit(pCursor, pParent, pData) {
            result := visitor(CXCursor.At(pCursor), CXCursor.At(pParent))
            if !IsSet(result)
                return CXChildVisitResult.Continue
            return result is CXChildVisitResult ? result.value : result
        }
    }

    /**
     * Collects the immediate children of this cursor into an array of independent (cloned) cursors.
     * @returns {Array} An array of `CXCursor`.
     */
    Children() {
        out := []
        this.Visit((c, p) => (out.Push(c.Clone()), CXChildVisitResult.Continue))
        return out
    }
}
