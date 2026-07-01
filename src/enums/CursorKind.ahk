#Requires AutoHotkey v2.1-alpha.30+

/**
 * Describes the kind of entity that a cursor refers to.
 * @see https://clang.llvm.org/doxygen/group__CINDEX.html#gaaccc432245b4cd9f2d470913f9ef0013
 */
export default struct CursorKind {
    value: UInt32

    __value {
        get => this.value
        set {
            if value < 0 || value > CursorKind.LAST {
                throw TypeError("Not a valid CursorKind", -1, value)
            }

            this.value := value
        }
    }

    /**
     * A declaration whose specific kind is not exposed via this interface.
     * 
     * Unexposed declarations have the same operations as any other kind of declaration; one can extract their
     * location information, spelling, find their definitions, etc. However, the specific kind of the declaration is
     * not reported.
     */
    static UnexposedDecl => 1
    /**
     * A C or C++ struct.
     */
    static StructDecl => 2
    /**
     * A C or C++ union.
     */
    static UnionDecl => 3
    /**
     * A C++ class.
     */
    static ClassDecl => 4
    /**
     * An enumeration.
     */
    static EnumDecl => 5
    /**
     * A field (in C) or non-static data member (in C++) in a struct, union, or C++ class.
     */
    static FieldDecl => 6
    /**
     * An enumerator constant.
     */
    static EnumConstantDecl => 7
    /**
     * A function.
     */
    static FunctionDecl => 8
    /**
     * A variable.
     */
    static VarDecl => 9
    /**
     * A function or method parameter.
     */
    static ParmDecl => 10
    /**
     * An Objective-C @interface.
     */
    static ObjCInterfaceDecl => 11
    /**
     * An Objective-C @interface for a category.
     */
    static ObjCCategoryDecl => 12
    /**
     * An Objective-C @protocol declaration.
     */
    static ObjCProtocolDecl => 13
    /**
     * An Objective-C @property declaration.
     */
    static ObjCPropertyDecl => 14
    /**
     * An Objective-C instance variable.
     */
    static ObjCIvarDecl => 15
    /**
     * An Objective-C instance method.
     */
    static ObjCInstanceMethodDecl => 16
    /**
     * An Objective-C class method.
     */
    static ObjCClassMethodDecl => 17
    /**
     * An Objective-C @implementation.
     */
    static ObjCImplementationDecl => 18
    /**
     * An Objective-C @implementation for a category.
     */
    static ObjCCategoryImplDecl => 19
    /**
     * A typedef.
     */
    static TypedefDecl => 20 
    /**
     * A C++ class method.
     */
    static CXXMethod => 21
    /**
     * A C++ namespace.
     */
    static Namespace => 22
    /**
     * 	A linkage specification, e.g.
     * 
     * ```cpp
     * extern "C".
     * ```
     */
    static LinkageSpec => 23
    /**
     * A C++ constructor.
     */
    static Constructor => 24
    /**
     * A C++ destructor
     */
    static Destructor => 25
    /**
     * A C++ conversion function.
     */
    static ConversionFunction => 26
    /**
     * A C++ template type parameter.
     */
    static TemplateTypeParameter => 27
    /**
     * A C++ non-type template parameter.
     */
    static NonTypeTemplateParameter => 28
    /**
     * A C++ template template parameter. 
     */
    static TemplateTemplateParameter => 29
    /**
     * A C++ class template.
     */
    static FunctionTemplate => 30
    /**
     * A C++ class template partial specialization.
     */
    static ClassTemplate => 31
    /**
     * A C++ class template partial specialization.
     */
    static ClassTemplatePartialSpecialization => 32
    /**
     * A C++ namespace alias declaration.
     */
    static NamespaceAlias => 33
    /**
     * A C++ using directive.
     */
    static UsingDirective => 34
    /**
     * A C++ using declaration.
     */
    static UsingDeclaration => 35
    /**
     * A C++ alias declaration.
     */
    static TypeAliasDecl => 36
    /**
     * An Objective-C @synthesize definition.
     */
    static ObjCSynthesizeDecl => 37
    /**
     * An Objective-C @dynamic definition.
     */
    static ObjCDynamicDecl => 38
    /**
     * An access specifier.
     */
    static CXXAccessSpecifier => 39
    static FirstDecl => CursorKind.UnexposedDecl
    static LastDecl => CursorKind.CXXAccessSpecifier
    static FirstRef => 40
    static ObjCSuperClassRef => 40
    static ObjCProtocolRef => 41
    static ObjCClassRef => 42
    /**
     * A reference to a type declaration.
     * 
     * A type reference occurs anywhere where a type is named but not declared. For example, given:
     * 
     * ```cpp
     * typedef unsigned size_type;
     * size_type size;
     * ```
     * 
     * The typedef is a declaration of size_type (CXCursor_TypedefDecl), while the type of the variable "size" is
     * referenced. The cursor referenced by the type of size is the typedef for size_type.
     */
    static TypeRef => 43
    static CXXBaseSpecifier => 44
    /**
     * A reference to a class template, function template, template template parameter, or class template partial
     * specialization.
     */
    static TemplateRef => 45
    /**
     * A reference to a namespace or namespace alias.
     */
    static NamespaceRef => 46
    /**
     * A reference to a member of a struct, union, or class that occurs in some non-expression context, e.g., a
     * designated initializer.
     */
    static MemberRef => 47
    /**
     * A reference to a labeled statement.
     * 
     * This cursor kind is used to describe the jump to "start_over" in the goto statement in the following example:
     * ```cpp
     * start_over:
     *   ++counter;
     *   goto start_over;
     * ```
     * A label reference cursor refers to a label statement.
     */
    static LabelRef => 48
    /**
     * A reference to a set of overloaded functions or function templates that has not yet been resolved to a specific
     * function or function template.
     * 
     * An overloaded declaration reference cursor occurs in C++ templates where a dependent name refers to a function.
     * For example:
     * ```cpp
     * template<typename T> void swap(T&, T&);
     * 
     * struct X { ... };
     * void swap(X&, X&);
     * 
     * template<typename T>
     * void reverse(T* first, T* last) {
     *   while (first < last - 1) {
     *     swap(*first, *--last);
     *     ++first;
     *   }
     * }
     * 
     * struct Y { };
     * void swap(Y&, Y&);
     * ```
     * 
     * Here, the identifier "swap" is associated with an overloaded declaration reference. In the template definition,
     * "swap" refers to either of the two "swap" functions declared above, so both results will be available. At
     * instantiation time, "swap" may also refer to other functions found via argument-dependent lookup (e.g., the
     * "swap" function at the end of the example).
     * 
     * The functions clang_getNumOverloadedDecls() and clang_getOverloadedDecl() can be used to retrieve the
     * definitions referenced by this cursor.
     */
    static OverloadedDeclRef => 49
    /**
     * A reference to a variable that occurs in some non-expression context, e.g., a C++ lambda capture list.
     */
    static VariableRef => 50
    static LastRef => CursorKind.VariableRef
    static FirstInvalid => 70
    static InvalidFile => 70
    static NoDeclFound => 71
    static NotImplemented => 72
    static InvalidCode => 73
    static LastInvalid => CursorKind.InvalidCode
    static FirstExpr => 100
    /**
     * An expression whose specific kind is not exposed via this interface.
     * 
     * Unexposed expressions have the same operations as any other kind of expression; one can extract their location
     * information, spelling, children, etc. However, the specific kind of the expression is not reported.
     */
    static UnexposedExpr => 100
    /**
     * An expression that refers to some value declaration, such as a function, variable, or enumerator.
     */
    static DeclRefExpr => 101
    /**
     * An expression that refers to a member of a struct, union, class, Objective-C class, etc.
     */
    static MemberRefExpr => 102
    /**
     * An expression that calls a function.
     */
    static CallExpr => 103
    /**
     * An expression that sends a message to an Objective-C object or class.
     */
    static ObjCMessageExpr => 104
    /**
     * An expression that represents a block literal.
     */
    static BlockExpr => 105
    /**
     * An integer literal.
     */
    static IntegerLiteral => 106
    /**
     * A floating point number literal.
     */
    static FloatingLiteral => 107
    /**
     * An imaginary number literal.
     */
    static ImaginaryLiteral => 108
    /**
     * A string literal.
     */
    static StringLiteral => 109
    /**
     * A character literal.
     */
    static CharacterLiteral => 110
    /**
     * A parenthesized expression, e.g.
     * ```cpp
     * "(1)"
     * ```
     * This AST node is only formed if full location information is requested.
     */
    static ParenExpr => 111
    /**
     * This represents the unary-expression's (except sizeof and alignof).
     */
    static UnaryOperator => 112
    /**
     * [C99 6.5.2.1] Array Subscripting.
     */
    static ArraySubscriptExpr => 113
    /**
     * A builtin binary operation expression such as "x + y" or "x <= y".
     */
    static BinaryOperator => 114
    /**
     * Compound assignment such as "+=".
     */
    static CompoundAssignOperator => 115
    /**
     * The ? : ternary operator.
     */
    static ConditionalOperator => 116
    /**
     * An explicit cast in C (C99 6.5.4) or a C-style cast in C++ (C++ [expr.cast]), which uses the syntax (Type)expr.
     * 
     * For example: (int)f.
     */
    static CStyleCastExpr => 117
    /**
     * [C99 6.5.2.5]
     */
    static CompoundLiteralExpr => 118
    /**
     * Describes an C or C++ initializer list.
     */
    static InitListExpr => 119
    /**
     * The GNU address of label extension, representing &&label.
     */
    static AddrLabelExpr => 120
    /**
     * This is the GNU Statement Expression extension: (`{int X=4; X;}`)
     */
    static StmtExpr => 121
    /**
     * Represents a C11 generic selection.
     */
    static GenericSelectionExpr => 122
    /**
     * Implements the GNU __null extension, which is a name for a null pointer constant that has integral type (e.g.,
     * int or long) and is the same size and alignment as a pointer.
     * 
     * The __null extension is typically only used by system headers, which define NULL as __null in C++ rather than
     * using 0 (which is an integer that may not match the size of a pointer).
     */
    static GNUNullExpr => 123
    /**
     * C++'s static_cast<> expression.
     */
    static CXXStaticCastExpr => 124
    /**
     * C++'s dynamic_cast<> expression.
     */
    static CXXDynamicCastExpr => 125
    /**
     * C++'s reinterpret_cast<> expression.
     */
    static CXXReinterpretCastExpr => 126
    /**
     * C++'s const_cast<> expression.
     */
    static CXXConstCastExpr => 127
    /**
     * Represents an explicit C++ type conversion that uses "functional" notion (C++ [expr.type.conv]).
     * 
     * Example:
     * ```cpp
     * x = int(0.5);
     * ```
     */
    static CXXFunctionalCastExpr => 128
    /**
     * A C++ typeid expression (C++ [expr.typeid]).
     */
    static CXXTypeidExpr => 129
    /**
     * [C++ 2.13.5] C++ Boolean Literal.
     */
    static CXXBoolLiteralExpr => 130
    /**
     * [C++0x 2.14.7] C++ Pointer Literal.
     */
    static CXXNullPtrLiteralExpr => 131
    /**
     * Represents the "this" expression in C++.
     */
    static CXXThisExpr => 132
    /**
     * [C++ 15] C++ Throw Expression.
     * 
     * This handles 'throw' and 'throw' assignment-expression. When assignment-expression isn't present, Op will be
     * null.
     */
    static CXXThrowExpr => 133
    /**
     * A new expression for memory allocation and constructor calls, e.g: "new CXXNewExpr(foo)".
     */
    static CXXNewExpr => 134
    /**
     * A delete expression for memory deallocation and destructor calls, e.g. "delete[] pArray".
     */
    static CXXDeleteExpr => 135
    /**
     * A unary expression. (noexcept, sizeof, or other traits)
     */
    static UnaryExpr => 136
    /**
     * An Objective-C string literal i.e. "foo".
     */
    static ObjCStringLiteral => 137
    /**
     * An Objective-C @encode expression.
     */
    static ObjCEncodeExpr => 138
    /**
     * An Objective-C @selector expression.
     */
    static ObjCSelectorExpr => 139
    /**
     * An Objective-C @protocol expression.
     */
    static ObjCProtocolExpr => 140
    /**
     * An Objective-C "bridged" cast expression, which casts between Objective-C pointers and C pointers, transferring
     * ownership in the process.
     * 
     * ```objective-c
     * NSString *str = (__bridge_transfer NSString *)CFCreateString();
     * ```
     */
    static ObjCBridgedCastExpr => 141
    /**
     * Represents a C++0x pack expansion that produces a sequence of expressions.
     * 
     * A pack expansion expression contains a pattern (which itself is an expression) followed by an ellipsis. For
     * example:
     * 
     * ```cpp
     * template<typename F, typename ...Types>
     * void forward(F f, Types &&...args) {
     *   f(static_cast<Types&&>(args)...);
     * }
     * ```
     */
    static PackExpansionExpr => 142
    /**
     * Represents an expression that computes the length of a parameter pack.
     * 
     * ```cpp
     * template<typename ...Types>
     * struct count {
     *   static const unsigned value = sizeof...(Types);
     * };
     * ```
     */
    static SizeOfPackExpr => 143
    static LambdaExpr => 144
    /**
     * Objective-c Boolean Literal.
     */
    static ObjCBoolLiteralExpr => 145
    /**
     * Represents the "self" expression in an Objective-C method.
     */
    static ObjCSelfExpr => 146
    /**
     * OpenMP 5.0 [2.1.5, Array Section].
     * 
     * OpenACC 3.3 [2.7.1, Data Specification for Data Clauses (Sub Arrays)]
     */
    static ArraySectionExpr => 147
    /**
     * Represents an @available(...) check.
     */
    static ObjCAvailabilityCheckExpr => 148
    /**
     * Fixed point literal.
     */
    static FixedPointLiteral => 149
    static OMPArrayShapingExpr => 150
    static OMPIteratorExpr => 151
    static CXXAddrspaceCastExpr => 152
    static ConceptSpecializationExpr => 153
    static RequiresExpr => 154
    static CXXParenListInitExpr => 155
    static PackIndexingExpr => 156
    static LastExpr => CursorKind.PackIndexingExpr 
    static FirstStmt => 200
    static UnexposedStmt => 200
    static LabelStmt => 201
    static CompoundStmt => 202
    static CaseStmt => 203
    static DefaultStmt => 204
    static IfStmt => 205
    static SwitchStmt => 206
    static WhileStmt => 207
    static DoStmt => 208
    static ForStmt => 209
    static GotoStmt => 210
    static IndirectGotoStmt => 211
    static ContinueStmt => 212
    static BreakStmt => 213
    static ReturnStmt => 214
    /**
     * A GCC inline assembly statement extension.
     */
    static GCCAsmStmt => 215
    static AsmStmt => CursorKind.GCCAsmStmt
    /**
     * Objective-C's overall @try-@catch-@finally statement.
     */
    static ObjCAtTryStmt => 216
    static ObjCAtCatchStmt => 217
    static ObjCAtFinallyStmt => 218
    static ObjCAtThrowStmt => 219
    static ObjCAtSynchronizedStmt => 220
    static ObjCAutoreleasePoolStmt => 221
    static ObjCForCollectionStmt => 222
    /**
     * C++'s catch statement.
     */
    static CXXCatchStmt => 223
    /**
     * C++'s try statement.
     */
    static CXXTryStmt => 224
    /**
     * C++'s for (* : *) statement.
     */
    static CXXForRangeStmt => 225
    static SEHTryStmt => 226
    static SEHExceptStmt => 227
    static SEHFinallyStmt => 228
    static MSAsmStmt => 229
    /**
     * The null statement ";": C99 6.8.3p3.
     * 
     * This cursor kind is used to describe the null statement.
     */
    static NullStmt => 230
    static DeclStmt => 231
    static OMPParallelDirective => 232
    static OMPSimdDirective => 233
    static OMPForDirective => 234
    static OMPSectionsDirective => 235
    static OMPSectionDirective => 236
    static OMPSingleDirective => 237
    static OMPParallelForDirective => 238
    static OMPParallelSectionsDirective => 239
    static OMPTaskDirective => 240
    static OMPMasterDirective => 241
    static OMPCriticalDirective => 242
    static OMPTaskyieldDirective => 243
    static OMPBarrierDirective => 244
    static OMPTaskwaitDirective => 245
    static OMPFlushDirective => 246
    static SEHLeaveStmt => 247
    static OMPOrderedDirective => 248
    static OMPAtomicDirective => 249
    static OMPForSimdDirective => 250
    static OMPParallelForSimdDirective => 251
    static OMPTargetDirective => 252
    static OMPTeamsDirective => 253
    static OMPTaskgroupDirective => 254
    static OMPCancellationPointDirective => 255
    static OMPCancelDirective => 256
    static OMPTargetDataDirective => 257
    static OMPTaskLoopDirective => 258
    static OMPTaskLoopSimdDirective => 259
    static OMPDistributeDirective => 260
    static OMPTargetEnterDataDirective => 261
    static OMPTargetExitDataDirective => 262
    static OMPTargetParallelDirective => 263
    static OMPTargetParallelForDirective => 264
    static OMPTargetUpdateDirective => 265
    static OMPDistributeParallelForDirective => 266
    static OMPDistributeParallelForSimdDirective => 267
    static OMPDistributeSimdDirective => 268
    static OMPTargetParallelForSimdDirective => 269
    static OMPTargetSimdDirective => 270
    static OMPTeamsDistributeDirective => 271
    static OMPTeamsDistributeSimdDirective => 272
    static OMPTeamsDistributeParallelForSimdDirective => 273
    static OMPTeamsDistributeParallelForDirective => 274
    static OMPTargetTeamsDirective => 275
    static OMPTargetTeamsDistributeDirective => 276
    static OMPTargetTeamsDistributeParallelForDirective => 277
    static OMPTargetTeamsDistributeParallelForSimdDirective => 278
    static OMPTargetTeamsDistributeSimdDirective => 279
    /**
     * C++2a std::bit_cast expression.
     */
    static BuiltinBitCastExpr => 280
    static OMPMasterTaskLoopDirective => 281
    static OMPParallelMasterTaskLoopDirective => 282
    static OMPMasterTaskLoopSimdDirective => 283
    static OMPParallelMasterTaskLoopSimdDirective => 284
    static OMPParallelMasterDirective => 285
    static OMPDepobjDirective => 286
    static OMPScanDirective => 287
    static OMPTileDirective => 288
    static OMPCanonicalLoop => 289
    static OMPInteropDirective => 290
    static OMPDispatchDirective => 291
    static OMPMaskedDirective => 292
    static OMPUnrollDirective => 293
    static OMPMetaDirective => 294
    static OMPGenericLoopDirective => 295
    static OMPTeamsGenericLoopDirective => 296
    static OMPTargetTeamsGenericLoopDirective => 297
    static OMPParallelGenericLoopDirective => 298
    static OMPTargetParallelGenericLoopDirective => 299
    static OMPParallelMaskedDirective => 300
    static OMPMaskedTaskLoopDirective => 301
    static OMPMaskedTaskLoopSimdDirective => 302
    static OMPParallelMaskedTaskLoopDirective => 303
    static OMPParallelMaskedTaskLoopSimdDirective => 304
    static OMPErrorDirective => 305
    static OMPScopeDirective => 306
    static OMPReverseDirective => 307
    static OMPInterchangeDirective => 308
    static OMPAssumeDirective => 309
    static OMPStripeDirective => 310
    static OMPFuseDirective => 311
    static OMPSplitDirective => 312
    static OpenACCComputeConstruct => 320
    static OpenACCLoopConstruct => 321
    static OpenACCCombinedConstruct => 322
    static OpenACCDataConstruct => 323
    static OpenACCEnterDataConstruct => 324
    static OpenACCExitDataConstruct => 325
    static OpenACCHostDataConstruct => 326
    static OpenACCWaitConstruct => 327
    static OpenACCInitConstruct => 328
    static OpenACCShutdownConstruct => 329
    static OpenACCSetConstruct => 330
    static OpenACCUpdateConstruct => 331
    static OpenACCAtomicConstruct => 332
    static OpenACCCacheConstruct => 333
    static LastStmt => CursorKind.OpenACCCacheConstruct
    /**
     * Cursor that represents the translation unit itself.
     * 
     * The translation unit cursor exists primarily to act as the root cursor for traversing the contents of a
     * translation unit.
     */
    static TranslationUnit => 350
    static FirstAttr => 400
    static UnexposedAttr => 400
    static IBActionAttr => 401
    static IBOutletAttr => 402
    static IBOutletCollectionAttr => 403
    static CXXFinalAttr => 404
    static CXXOverrideAttr => 405
    static AnnotateAttr => 406
    static AsmLabelAttr => 407
    static PackedAttr => 408
    static PureAttr => 409
    static ConstAttr => 410
    static NoDuplicateAttr => 411
    static CUDAConstantAttr => 412
    static CUDADeviceAttr => 413
    static CUDAGlobalAttr => 414
    static CUDAHostAttr => 415
    static CUDASharedAttr => 416
    static VisibilityAttr => 417
    static DLLExport => 418
    static DLLImport => 419
    static NSReturnsRetained => 420
    static NSReturnsNotRetained => 421
    static NSReturnsAutoreleased => 422
    static NSConsumesSelf => 423
    static NSConsumed => 424
    static ObjCException => 425
    static ObjCNSObject => 426
    static ObjCIndependentClass => 427
    static ObjCPreciseLifetime => 428
    static ObjCReturnsInnerPointer => 429
    static ObjCRequiresSuper => 430
    static ObjCRootClass => 431
    static ObjCSubclassingRestricted => 432
    static ObjCExplicitProtocolImpl => 433
    static ObjCDesignatedInitializer => 434
    static ObjCRuntimeVisible => 435
    static ObjCBoxable => 436
    static FlagEnum => 437
    static ConvergentAttr => 438
    static WarnUnusedAttr => 439
    static WarnUnusedResultAttr => 440
    static AlignedAttr => 441
    static LastAttr => CursorKind.AlignedAttr
    static PreprocessingDirective => 500
    static MacroDefinition => 501
    static MacroExpansion => 502
    static MacroInstantiation => CursorKind.MacroExpansion
    static InclusionDirective => 503
    static FirstPreprocessing => CursorKind.PreprocessingDirective
    static LastPreprocessing => CursorKind.InclusionDirective
    static ModuleImportDecl => 600
    static TypeAliasTemplateDecl => 601
    /**
     * A static_assert or _Static_assert node.
     */
    static StaticAssert => 602
    static FriendDecl => 603
    static ConceptDecl => 604
    static FirstExtraDecl => CursorKind.ModuleImportDecl
    static LastExtraDecl => CursorKind.ConceptDecl
    /**
     * A code completion overload candidate.
     */
    static OverloadCandidate => 700

    ; Not from the enum, used to ensure valid
    static LAST => CursorKind.OverloadCandidate
}