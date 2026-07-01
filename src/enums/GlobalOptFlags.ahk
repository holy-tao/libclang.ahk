#Requires AutoHotkey v2.1-alpha.30+

export default struct GlobalOptFlags {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /**
     * Used to indicate that no special CXIndex options are needed.
     */
    static None => 0

    /**
     * Used to indicate that threads that libclang creates for indexing purposes should use background priority.
     *
     * Affects clang_indexSourceFile, clang_indexTranslationUnit, clang_parseTranslationUnit, clang_saveTranslationUnit.
     */
    static ThreadBackgroundPriorityForIndexing => 0x1

    /**
     * Used to indicate that threads that libclang creates for editing purposes should use background priority.
     *
     * Affects clang_reparseTranslationUnit, clang_codeCompleteAt, clang_annotateTokens
     */
    static ThreadBackgroundPriorityForEditing => 0x2
 
    /**
     * Used to indicate that all threads that libclang creates should use background priority.
     */
    static ThreadBackgroundPriorityForAll =>
        GlobalOptFlags.ThreadBackgroundPriorityForIndexing |
        GlobalOptFlags.ThreadBackgroundPriorityForEditing
}