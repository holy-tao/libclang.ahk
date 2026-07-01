#Requires AutoHotkey v2.1-alpha.30+

#Import CXFile

/**
 * Identifies a specific source location within a translation unit.
 *
 * `CXSourceLocation` is a value type whose `ptr_data` references the owning translation unit, so it is only valid
 * while that translation unit is alive.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html
 */
export default struct CXSourceLocation {
    ptr_data: IntPtr[2]
    int_data: UInt32

    /** True if this location is in a system header (per `#include <...>` / `-isystem`). */
    IsInSystemHeader => DllCall("libclang\clang_Location_isInSystemHeader", CXSourceLocation, this, Int32) != 0

    /** True if this location is in the main file of its translation unit (not an included header). */
    IsFromMainFile => DllCall("libclang\clang_Location_isFromMainFile", CXSourceLocation, this, Int32) != 0

    /** Determines whether two source locations refer to the same location. */
    Equals(other) => DllCall("libclang\clang_equalLocations", CXSourceLocation, this, CXSourceLocation, other, UInt32) != 0

    /**
     * Decomposes this location into the file, line, column and character offset it refers to. This maps macro
     * expansions back to the spelling location in the file where the token was originally written.
     * @returns {Object} `{ file: CXFile, line, column, offset }` (line and column are 1-based).
     */
    FileLocation() {
        fileHandle := 0, line := 0, column := 0, offset := 0
        DllCall("libclang\clang_getFileLocation",
            CXSourceLocation, this,
            IntPtr.Ptr, &fileHandle,
            UInt32.Ptr, &line,
            UInt32.Ptr, &column,
            UInt32.Ptr, &offset,
            "void")
        f := CXFile()
        f.ptr := fileHandle
        return { file: f, line: line, column: column, offset: offset }
    }
}
