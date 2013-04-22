package LibStorage::SubvolInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string", "&string"],
        swig_path_get => ["function", "string", "any"],
        swig_path_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_path_get {}
sub swig_path_set {}
1;
