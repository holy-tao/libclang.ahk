#Requires AutoHotkey v2.1-alpha.30+ 64-bit

/**
 * A character string.
 * 
 * The `CXString` type is used to return strings from the interface when the ownership of that string might differ
 * from one call to the next.
 */
export default struct CXString {
    data: IntPtr
    private_flags: UInt32

    ToString() => DllCall("libclang\clang_getCString", CXString, this, "astr")

    __Delete() => DllCall("libclang\clang_disposeString", CXString, this, "void")
}