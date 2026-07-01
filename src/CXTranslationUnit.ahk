#Requires AutoHotkey v2.1-alpha.30+

#Import Enums {CXDiagnosticSeverity}
#Import CXCursor
#Import CXFile
#Import CXDiagnostic

/**
 * A single translation unit, which resides in an index (`CXIndex`).
 *
 * Underlying handle is a pointer owned by libclang. The translation unit must not outlive the `CXIndex` it was
 * parsed from; keep a reference to that index alive for as long as you use this translation unit. The handle is
 * released automatically when this object is destroyed.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html
 */
export default struct CXTranslationUnit {
    ptr: IntPtr

    /** The cursor representing the root of the translation unit (the entire file). */
    Cursor => DllCall("libclang\clang_getTranslationUnitCursor", CXTranslationUnit, this, CXCursor)

    /**
     * Retrieves a file handle within this translation unit by name (as it appears in the compile command / includes).
     * @param {String} name The file path.
     * @returns {CXFile} The file handle; its `IsNull` is true if the file is not part of this translation unit.
     */
    File(name) {
        nameBuf := Buffer(StrPut(name, "UTF-8"))
        StrPut(name, nameBuf, "UTF-8")
        return DllCall("libclang\clang_getFile", CXTranslationUnit, this, IntPtr, nameBuf.ptr, CXFile)
    }

    /** The number of diagnostics produced for this translation unit. */
    NumDiagnostics => DllCall("libclang\clang_getNumDiagnostics", CXTranslationUnit, this, UInt32)

    /**
     * Retrieves the diagnostic at the given index (0-based).
     * @param {Integer} index In the range `[0, NumDiagnostics)`.
     * @returns {CXDiagnostic}
     */
    Diagnostic(index) => DllCall("libclang\clang_getDiagnostic", CXTranslationUnit, this, UInt32, index, CXDiagnostic)

    /**
     * Collects all diagnostics for this translation unit.
     * @returns {Array} An array of `CXDiagnostic`.
     */
    Diagnostics() {
        out := []
        loop this.NumDiagnostics
            out.Push(this.Diagnostic(A_Index - 1))
        return out
    }

    /** True if any diagnostic is of `Error` severity or higher (i.e. the parse is not fully valid). */
    HasErrors {
        get {
            loop this.NumDiagnostics {
                if this.Diagnostic(A_Index - 1).Severity >= CXDiagnosticSeverity.Error
                    return true
            }
            return false
        }
    }

    __Delete() {
        if this.ptr
            DllCall("libclang\clang_disposeTranslationUnit", CXTranslationUnit, this, "void")
    }
}
