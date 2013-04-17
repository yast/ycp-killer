package LibStorage::DlabelCapabilities;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_maxPrimary_get => ["function", "integer", "any"],
        swig_maxPrimary_set => ["function", "void", "any", "integer"],
        swig_extendedPossible_get => ["function", "boolean", "any"],
        swig_extendedPossible_set => ["function", "void", "any", "boolean"],
        swig_maxLogical_get => ["function", "integer", "any"],
        swig_maxLogical_set => ["function", "void", "any", "integer"],
        swig_maxSectors_get => ["function", "integer", "any"],
        swig_maxSectors_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_maxPrimary_get {}
sub swig_maxPrimary_set {}
sub swig_extendedPossible_get {}
sub swig_extendedPossible_set {}
sub swig_maxLogical_get {}
sub swig_maxLogical_set {}
sub swig_maxSectors_get {}
sub swig_maxSectors_set {}
1;
