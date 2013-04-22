package LibStorage::MdStateInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_state_get => ["function", "integer", "any"],
        swig_state_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_state_get {}
sub swig_state_set {}
1;
