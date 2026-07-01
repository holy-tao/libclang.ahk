#Requires AutoHotkey v2.1-alpha.30+

#Import Enums {CXTypeKind}
#Import CXString
#Import CXCursor

/**
 * The type of an element in the abstract syntax tree.
 *
 * `CXType` is a value type returned by libclang. The `data` pointers reference the owning translation unit, so a
 * `CXType` is only valid while that translation unit is alive.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html
 */
export default struct CXType {
    /** The kind of type. */
    kind: CXTypeKind
    data: IntPtr[2]

    /** 
     * Pretty-print the underlying type, e.g. "const char *".
     */
    Spelling => DllCall("libclang\clang_getTypeSpelling", CXType, this, CXString).ToString()

    /** 
     * The spelling of this type's `kind`, e.g. "Int", "Pointer", "FunctionProto".
     */
    KindSpelling => DllCall("libclang\clang_getTypeKindSpelling", "int", this.kind, CXString).ToString()

    ToString() => this.Spelling

    /**
     * The canonical type with all "sugar" (typedefs, etc.) removed. Use this to resolve a typedef chain down to the
     * concrete underlying type.
     */
    Canonical => DllCall("libclang\clang_getCanonicalType", CXType, this, CXType)

    /** 
     * True if this type is `const`-qualified.
     */
    IsConstQualified => DllCall("libclang\clang_isConstQualifiedType", CXType, this, "uint") != 0

    /** 
     * For pointer types, the type being pointed to.
     */
    Pointee => DllCall("libclang\clang_getPointeeType", CXType, this, CXType)

    /**
     * For array types, the element type.
     */
    ElementType => DllCall("libclang\clang_getArrayElementType", CXType, this, CXType)

    /**
     * For constant array types, the number of elements; -1 if not an array of constant size.
     */
    ArraySize => DllCall("libclang\clang_getArraySize", CXType, this, "int64")

    /**
     * For function types, the return type.
     */
    ResultType => DllCall("libclang\clang_getResultType", CXType, this, CXType)

    /**
     * For function-proto types, the number of non-variadic parameters; -1 if not a function type.
     */
    NumArgTypes => DllCall("libclang\clang_getNumArgTypes", CXType, this, "int")

    /**
     * For function-proto types, the type of parameter `i` (0-based).
     */
    ArgType(i) => DllCall("libclang\clang_getArgType", CXType, this, "uint", i, CXType)

    /**
     * The size of this type in bytes, as `sizeof` would report. Negative values are `CXTypeLayoutError` codes
     * (e.g. -2 invalid, -3 incomplete, -4 dependent).
     */
    SizeOf => DllCall("libclang\clang_Type_getSizeOf", CXType, this, "int64")

    /**
     * The alignment of this type in bytes. Negative values are `CXTypeLayoutError` codes.
     */
    AlignOf => DllCall("libclang\clang_Type_getAlignOf", CXType, this, "int64")

    /**
     * The offset of the named field within a record type, **in bits** (libclang reports field offsets in bits, not
     * bytes; divide by 8 for whole-byte fields). Negative values are `CXTypeLayoutError` codes.
     * @param {String} field The field name.
     */
    OffsetOf(field) => DllCall("libclang\clang_Type_getOffsetOf", CXType, this, "astr", field, "int64")

    /**
     * The cursor for the declaration of this type (e.g. the `struct`/`enum`/`typedef` declaration).
     */
    Declaration => DllCall("libclang\clang_getTypeDeclaration", CXType, this, CXCursor)

    /**
     * Determines whether two `CXType` values represent the same type.
     */
    Equals(other) => DllCall("libclang\clang_equalTypes", CXType, this, CXType, other, "uint") != 0
}
