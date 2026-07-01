#Requires AutoHotkey v2.1-alpha.30+

/**
 * Describes a version number of the form major.minor.subminor.
 */
export default struct CXVersion {
    /**
     * The major version number, e.g., the '10' in '10.7.3'. A negative
     * value indicates that there is no version number at all.
     */
    Major: Int32
    /**
     * The minor version number, e.g., the '7' in '10.7.3'. This value
     * will be negative if no minor version number was provided, e.g., for
     * version '10'.
     */
    Minor: Int32
    /**
     * The subminor version number, e.g., the '3' in '10.7.3'. This value
     * will be negative if no minor or subminor version number was provided,
     * e.g., in version '10' or '10.7'.
     */
    Subminor: Int32

    ToString() {
        out := ""
        if this.Major >= 0
            out .= this.Major

        if this.Minor >= 0
            out .= "." this.Minor

        if this.Subminor >= 0
            out .= "." this.Subminor

        return out
    }
}