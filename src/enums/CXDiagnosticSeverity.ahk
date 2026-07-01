#Requires AutoHotkey v2.1-alpha.30+

/**
 * Describes the severity of a particular diagnostic.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__DIAG.html
 */
export default struct CXDiagnosticSeverity {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /** A diagnostic that has been suppressed, e.g. by a command-line option. */
    static Ignored => 0
    /** This diagnostic is a note that should be attached to the previous (non-note) diagnostic. */
    static Note => 1
    /** This diagnostic indicates suspicious code that may not be wrong. */
    static Warning => 2
    /** This diagnostic indicates that the code is ill-formed. */
    static Error => 3
    /** This diagnostic indicates that the code is ill-formed such that meaningful recovery is unlikely. */
    static Fatal => 4
}
