#Requires AutoHotkey v2.1-alpha.30+

/**
 * Options to control the display of diagnostics, passed to `CXDiagnostic.Format`. The set returned by
 * `clang_defaultDiagnosticDisplayOptions` (used when `Format` is called with no argument) mirrors the default
 * behavior of the clang compiler.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html
 */
export default struct DiagnosticDisplayOptions {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /** Display the source-location information where the diagnostic was located. */
    static SourceLocation => 0x01
    /** Also display the column number of the source location (implies SourceLocation). */
    static Column => 0x02
    /** Display the source ranges that are part of this diagnostic. */
    static SourceRanges => 0x04
    /** Display the option name (e.g. "-Wunused") associated with this diagnostic, if any. */
    static Option => 0x08
    /** Display the category number associated with this diagnostic, if any. */
    static CategoryId => 0x10
    /** Display the category name associated with this diagnostic, if any. */
    static CategoryName => 0x20
}
