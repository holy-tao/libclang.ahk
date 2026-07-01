#Requires AutoHotkey v2.1-alpha.30+

/**
 * Flags that control the creation of translation units, passed to `CXIndex.ParseTranslationUnit`.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__TRANSLATION__UNIT.html
 */
export default struct TranslationUnitFlags {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /** Used to indicate that no special translation-unit options are needed. */
    static None => 0x0
    /** Used to indicate that the parser should construct a "detailed" preprocessing record. */
    static DetailedPreprocessingRecord => 0x01
    /** Used to indicate that the translation unit is incomplete (e.g. a header). */
    static Incomplete => 0x02
    /** Used to indicate that the translation unit should be built with an implicit precompiled preamble. */
    static PrecompiledPreamble => 0x04
    /** Used to indicate that the translation unit should cache some code-completion results. */
    static CacheCompletionResults => 0x08
    /** Used to indicate that the translation unit will be serialized with `clang_saveTranslationUnit`. */
    static ForSerialization => 0x10
    /** Used to indicate that function/method bodies should be skipped while parsing. */
    static SkipFunctionBodies => 0x40
    static IncludeBriefCommentsInCodeCompletion => 0x80
    static CreatePreambleOnFirstParse => 0x100
    /** Do not stop processing when fatal errors are encountered. */
    static KeepGoing => 0x200
    /** Sets the preprocessor in a mode for parsing a single file only. */
    static SingleFileParse => 0x400
    static LimitSkipFunctionBodiesToPreamble => 0x800
    static IncludeAttributedTypes => 0x1000
    static VisitImplicitAttributes => 0x2000
    static IgnoreNonErrorsFromIncludedFiles => 0x4000
    static RetainExcludedConditionalBlocks => 0x8000
}
