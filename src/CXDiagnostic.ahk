#Requires AutoHotkey v2.1-alpha.30+

#Import CXString
#Import CXSourceLocation

/**
 * A single diagnostic (error, warning, note, ...) produced while parsing a translation unit.
 *
 * The underlying handle is owned by the caller and is released automatically when this object is destroyed. Obtain
 * diagnostics via `CXTranslationUnit.Diagnostics` / `.Diagnostic(i)`.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html
 */
export default struct CXDiagnostic {
    ptr: IntPtr

    /** The severity of this diagnostic, as a `CXDiagnosticSeverity` value. */
    Severity => DllCall("libclang\clang_getDiagnosticSeverity", CXDiagnostic, this, Int32)

    /** The text of this diagnostic (the message itself, without location or severity). */
    Spelling => DllCall("libclang\clang_getDiagnosticSpelling", CXDiagnostic, this, CXString).ToString()

    /** The source location of this diagnostic. */
    Location => DllCall("libclang\clang_getDiagnosticLocation", CXDiagnostic, this, CXSourceLocation)

    /** The name of the diagnostic category (e.g. "Semantic Issue"), or "" if none. */
    CategoryText => DllCall("libclang\clang_getDiagnosticCategoryText", CXDiagnostic, this, CXString).ToString()

    /** The command-line option that enables this diagnostic (e.g. "-Wunused"), or "" if none. */
    Option => DllCall("libclang\clang_getDiagnosticOption", CXDiagnostic, this, IntPtr, 0, CXString).ToString()

    /**
     * Formats this diagnostic into a human-readable string in the manner the clang compiler would print it.
     * @param {Integer} options A bit set of `DiagnosticDisplayOptions`. Defaults to clang's default display options.
     */
    Format(options?) {
        if !IsSet(options)
            options := DllCall("libclang\clang_defaultDiagnosticDisplayOptions", UInt32)
        return DllCall("libclang\clang_formatDiagnostic", CXDiagnostic, this, UInt32, options, CXString).ToString()
    }

    ToString() => this.Format()

    __Delete() {
        if this.ptr
            DllCall("libclang\clang_disposeDiagnostic", CXDiagnostic, this, "void")
    }
}
