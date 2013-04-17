package LibStorage::ContentInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_windows_get => ["function", "boolean", "any"],
        swig_windows_set => ["function", "void", "any", "boolean"],
        swig_efi_get => ["function", "boolean", "any"],
        swig_efi_set => ["function", "void", "any", "boolean"],
        swig_homes_get => ["function", "integer", "any"],
        swig_homes_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_windows_get {}
sub swig_windows_set {}
sub swig_efi_get {}
sub swig_efi_set {}
sub swig_homes_get {}
sub swig_homes_set {}
1;
