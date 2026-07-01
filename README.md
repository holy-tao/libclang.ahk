# Libclang

Partial AutoHotkey bindings for Libclang. Consider these under development - my long-term goal is to use these 
build a bindings generator which can the generate these completely.

## Prerequisites

You need to load `libclang.dll` yourself. You can obtain it from the LLVM project's [releases](https://github.com/llvm/llvm-project/releases).


### Example

Prints all typedefs in "./test.h" and its included files
```autohotkey
#DllLoad "%A_ProgramFiles%/LLVM/bin/libclang.dll"

#Import src {*}

includePath := "C:\Program Files (x86)\Microsoft Visual Studio\18\BuildTools\VC\Tools\MSVC\14.50.35717\include"

idx := CXIndex.Create()
tu := idx.ParseTranslationUnit("./test.h", ["-std=c11", "-I", includePath],
    TranslationUnitFlags.SkipFunctionBodies | TranslationUnitFlags.DetailedPreprocessingRecord)

loop tu.NumDiagnostics
    FileAppend(tu.Diagnostic(A_Index - 1).ToString() "`n", "*")
if tu.HasErrors
    ExitApp(2)

tu.cursor.Visit(Walk)

/**
 * Visitor example
 * @param {CXCursor} cursor 
 * @param {CXCursor} _ 
 */
Walk(cursor, _) {
    if cursor.Kind == CursorKind.TypedefDecl {
        str := Format("Display: {1}, type: {2}, underlying: {3}, canonical: {4}",
            cursor.DisplayName, String(cursor.Type), String(cursor.UnderlyingType), String(cursor.Type.Canonical))
        FileAppend(str "`n", "*")
    }

    return CXChildVisitResult.Recurse
}
```
