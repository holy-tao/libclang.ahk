#Requires AutoHotkey v2.1-alpha.30+

#Import CXSourceLocation

/**
 * Identifies a half-open range of characters within a translation unit (`[Start, End)`).
 *
 * `CXSourceRange` is a value type whose `ptr_data` references the owning translation unit, so it is only valid while
 * that translation unit is alive.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__LOCATIONS.html
 */
export default struct CXSourceRange {
    ptr_data: IntPtr[2]
    begin_int_data: UInt32
    end_int_data: UInt32

    /** True if this range is null (invalid). */
    IsNull => DllCall("libclang\clang_Range_isNull", CXSourceRange, this, Int32) != 0

    /** The source location of the first character in the range. */
    Start => DllCall("libclang\clang_getRangeStart", CXSourceRange, this, CXSourceLocation)

    /** The source location one past the last character in the range. */
    End => DllCall("libclang\clang_getRangeEnd", CXSourceRange, this, CXSourceLocation)
}
