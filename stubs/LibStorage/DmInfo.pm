package LibStorage::DmInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
        swig_nr_get => ["function", "integer", "any"],
        swig_nr_set => ["function", "void", "any", "integer"],
        swig_table_get => ["function", "string", "any"],
        swig_table_set => ["function", "void", "any", "string"],
        swig_target_get => ["function", "string", "any"],
        swig_target_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
sub swig_nr_get {}
sub swig_nr_set {}
sub swig_table_get {}
sub swig_table_set {}
sub swig_target_get {}
sub swig_target_set {}
1;
