package LibStorage::NfsInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
1;
