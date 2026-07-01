#Requires AutoHotkey v2.1-alpha.30+

#Import CXTranslationUnit

/**
 * An "index" that consists of a set of translation units that would typically be linked together into an executable
 * or library. This is the top-level libclang object; create one with `CXIndex.Create()`.
 *
 * The underlying handle is released automatically when this object is destroyed. Any translation unit parsed from
 * this index must be disposed (or go out of scope) before the index does.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX.html
 */
export default struct CXIndex {
    ptr: IntPtr

    /**
     * Provides a shared context for creating translation units.
     * @param {Integer} excludeDeclarationsFromPCH When true, declarations from pre-compiled headers are not included
     *   in the set of cursors traversed by enumeration. Usually 0.
     * @param {Integer} displayDiagnostics When true, libclang prints diagnostics to stderr. Usually 0.
     */
    static Create(excludeDeclarationsFromPCH := false, displayDiagnostics := false) {
        idx := DllCall("libclang\clang_createIndex",
            Int32, excludeDeclarationsFromPCH,
            Int32, displayDiagnostics,
            CXIndex)
        if !idx.ptr
            throw OSError("clang_createIndex failed")
        return idx
    }

    /**
     * Parses a source file and produces a translation unit ready for AST traversal.
     * @param {String} sourceFile Path to the source file to parse.
     * @param {Array} args Command-line arguments to pass to the compiler (e.g. ["-I", "C:\\include", "-std=c11"]).
     * @param {Integer} options A bit set of `TranslationUnitFlags`.
     * @returns {CXTranslationUnit}
     */
    ParseTranslationUnit(sourceFile, args := [], options := 0) {
        ; libclang expects UTF-8; build a contiguous `const char* const*` argv plus a UTF-8 file name.
        argBufs := []  ; keep the string buffers alive until after the call
        argv := args.Length ? Buffer(args.Length * A_PtrSize) : 0
        for i, arg in args {
            buf := Buffer(StrPut(arg, "UTF-8"))
            StrPut(arg, buf, "UTF-8")
            argBufs.Push(buf)
            NumPut("Ptr", buf.Ptr, argv, (i - 1) * A_PtrSize)
        }

        fileBuf := Buffer(StrPut(sourceFile, "UTF-8"))
        StrPut(sourceFile, fileBuf, "UTF-8")

        tu := DllCall("libclang\clang_parseTranslationUnit",
            CXIndex, this,
            IntPtr, fileBuf.ptr,
            IntPtr, args.Length ? argv.ptr : 0,
            Int32, args.Length,
            IntPtr, 0,             ; unsaved_files
            UInt32, 0,            ; num_unsaved_files
            UInt32, options,
            CXTranslationUnit)

        if !tu.ptr
            throw OSError("Failed to parse translation unit: " sourceFile)
        return tu
    }

    __Delete() {
        if this.ptr
            DllCall("libclang\clang_disposeIndex", CXIndex, this, "void")
    }
}
