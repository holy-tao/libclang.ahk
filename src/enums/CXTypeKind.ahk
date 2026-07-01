#Requires AutoHotkey v2.1-alpha.30+

/**
 * Describes the kind of type.
 *
 * Only the kinds that can appear when parsing C are given named constants below; the OpenCL, Objective-C, HLSL and
 * Intel-subgroup kinds are omitted as a binding generator will never encounter them. Any value is still accepted.
 * To resolve a kind (including the omitted ones) to its name, use `CXType.KindSpelling`.
 *
 * @see https://clang.llvm.org/doxygen/group__CINDEX__TYPES.html
 */
export default struct CXTypeKind {
    value: UInt32

    __value {
        get => this.value
        set => this.value := value
    }

    /** Represents an invalid type (e.g., where no type is available). */
    static Invalid => 0
    /** A type whose specific kind is not exposed via this interface. */
    static Unexposed => 1
    static Void => 2
    static Bool => 3
    static Char_U => 4
    static UChar => 5
    static Char16 => 6
    static Char32 => 7
    static UShort => 8
    static UInt => 9
    static ULong => 10
    static ULongLong => 11
    static UInt128 => 12
    static Char_S => 13
    static SChar => 14
    static WChar => 15
    static Short => 16
    static Int => 17
    static Long => 18
    static LongLong => 19
    static Int128 => 20
    static Float => 21
    static Double => 22
    static LongDouble => 23
    static NullPtr => 24
    static Overload => 25
    static Dependent => 26
    static Float128 => 30
    static Half => 31
    static Float16 => 32
    static BFloat16 => 39
    static Ibm128 => 40
    static FirstBuiltin => CXTypeKind.Void
    static LastBuiltin => CXTypeKind.Ibm128

    static Complex => 100
    static Pointer => 101
    static BlockPointer => 102
    static LValueReference => 103
    static RValueReference => 104
    static Record => 105
    static Enum => 106
    static Typedef => 107
    static FunctionNoProto => 110
    static FunctionProto => 111
    static ConstantArray => 112
    static Vector => 113
    static IncompleteArray => 114
    static VariableArray => 115
    static DependentSizedArray => 116
    static MemberPointer => 117
    static Auto => 118
    /** Represents a type that was referred to using an elaborated type keyword, e.g. `struct S`. */
    static Elaborated => 119
    static Pipe => 120
    static Attributed => 163
    static ExtVector => 176
    static Atomic => 177
    static BTFTagAttributed => 178
}
