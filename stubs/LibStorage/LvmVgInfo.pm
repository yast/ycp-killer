package LibStorage::LvmVgInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_sizeK_get => ["function", "integer", "any"],
        swig_sizeK_set => ["function", "void", "any", "integer"],
        swig_peSizeK_get => ["function", "integer", "any"],
        swig_peSizeK_set => ["function", "void", "any", "integer"],
        swig_peCount_get => ["function", "integer", "any"],
        swig_peCount_set => ["function", "void", "any", "integer"],
        swig_peFree_get => ["function", "integer", "any"],
        swig_peFree_set => ["function", "void", "any", "integer"],
        swig_uuid_get => ["function", "string", "any"],
        swig_uuid_set => ["function", "void", "any", "string"],
        swig_lvm2_get => ["function", "boolean", "any"],
        swig_lvm2_set => ["function", "void", "any", "boolean"],
        swig_create_get => ["function", "boolean", "any"],
        swig_create_set => ["function", "void", "any", "boolean"],
        swig_devices_get => ["function", "string", "any"],
        swig_devices_set => ["function", "void", "any", "string"],
        swig_devices_add_get => ["function", "string", "any"],
        swig_devices_add_set => ["function", "void", "any", "string"],
        swig_devices_rem_get => ["function", "string", "any"],
        swig_devices_rem_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_sizeK_get {}
sub swig_sizeK_set {}
sub swig_peSizeK_get {}
sub swig_peSizeK_set {}
sub swig_peCount_get {}
sub swig_peCount_set {}
sub swig_peFree_get {}
sub swig_peFree_set {}
sub swig_uuid_get {}
sub swig_uuid_set {}
sub swig_lvm2_get {}
sub swig_lvm2_set {}
sub swig_create_get {}
sub swig_create_set {}
sub swig_devices_get {}
sub swig_devices_set {}
sub swig_devices_add_get {}
sub swig_devices_add_set {}
sub swig_devices_rem_get {}
sub swig_devices_rem_set {}
1;
