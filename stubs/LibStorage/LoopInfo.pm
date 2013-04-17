package LibStorage::LoopInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
        swig_reuseFile_get => ["function", "boolean", "any"],
        swig_reuseFile_set => ["function", "void", "any", "boolean"],
        swig_nr_get => ["function", "integer", "any"],
        swig_nr_set => ["function", "void", "any", "integer"],
        swig_file_get => ["function", "string", "any"],
        swig_file_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
sub swig_reuseFile_get {}
sub swig_reuseFile_set {}
sub swig_nr_get {}
sub swig_nr_set {}
sub swig_file_get {}
sub swig_file_set {}
1;
