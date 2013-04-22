package LibStorage::LvmLvInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
        swig_stripes_get => ["function", "integer", "any"],
        swig_stripes_set => ["function", "void", "any", "integer"],
        swig_stripeSizeK_get => ["function", "integer", "any"],
        swig_stripeSizeK_set => ["function", "void", "any", "integer"],
        swig_uuid_get => ["function", "string", "any"],
        swig_uuid_set => ["function", "void", "any", "string"],
        swig_status_get => ["function", "string", "any"],
        swig_status_set => ["function", "void", "any", "string"],
        swig_allocation_get => ["function", "string", "any"],
        swig_allocation_set => ["function", "void", "any", "string"],
        swig_dm_table_get => ["function", "string", "any"],
        swig_dm_table_set => ["function", "void", "any", "string"],
        swig_dm_target_get => ["function", "string", "any"],
        swig_dm_target_set => ["function", "void", "any", "string"],
        swig_origin_get => ["function", "string", "any"],
        swig_origin_set => ["function", "void", "any", "string"],
        swig_used_pool_get => ["function", "string", "any"],
        swig_used_pool_set => ["function", "void", "any", "string"],
        swig_pool_get => ["function", "boolean", "any"],
        swig_pool_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
sub swig_stripes_get {}
sub swig_stripes_set {}
sub swig_stripeSizeK_get {}
sub swig_stripeSizeK_set {}
sub swig_uuid_get {}
sub swig_uuid_set {}
sub swig_status_get {}
sub swig_status_set {}
sub swig_allocation_get {}
sub swig_allocation_set {}
sub swig_dm_table_get {}
sub swig_dm_table_set {}
sub swig_dm_target_get {}
sub swig_dm_target_set {}
sub swig_origin_get {}
sub swig_origin_set {}
sub swig_used_pool_get {}
sub swig_used_pool_set {}
sub swig_pool_get {}
sub swig_pool_set {}
1;
