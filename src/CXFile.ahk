#Requires AutoHotkey v2.1-alpha.30+

#Import CXString

/**
 * A particular source file that is part of a translation unit.
 *
 * The underlying handle is an opaque pointer owned by the translation unit; a `CXFile` is only valid while that
 * translation unit is alive and is not disposed by this wrapper.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__FILES.html
 */
export default struct CXFile {
    ptr: IntPtr

    /** True if this is a null file handle (e.g. a location with no associated file). */
    IsNull => !this.ptr

    /** The complete file and path name of this file, or "" if null. */
    Name => this.ptr ? DllCall("libclang\clang_getFileName", CXFile, this, CXString).ToString() : ""

    ToString() => this.Name
}
