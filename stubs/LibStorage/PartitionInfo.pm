package LibStorage::PartitionInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
        swig_nr_get => ["function", "integer", "any"],
        swig_nr_set => ["function", "void", "any", "integer"],
        swig_cylStart_get => ["function", "integer", "any"],
        swig_cylStart_set => ["function", "void", "any", "integer"],
        swig_cylSize_get => ["function", "integer", "any"],
        swig_cylSize_set => ["function", "void", "any", "integer"],
        swig_partitionType_get => ["function", "integer", "any"],
        swig_partitionType_set => ["function", "void", "any", "integer"],
        swig_id_get => ["function", "integer", "any"],
        swig_id_set => ["function", "void", "any", "integer"],
        swig_boot_get => ["function", "boolean", "any"],
        swig_boot_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
sub swig_nr_get {}
sub swig_nr_set {}
sub swig_cylStart_get {}
sub swig_cylStart_set {}
sub swig_cylSize_get {}
sub swig_cylSize_set {}
sub swig_partitionType_get {}
sub swig_partitionType_set {}
sub swig_id_get {}
sub swig_id_set {}
sub swig_boot_get {}
sub swig_boot_set {}
1;
