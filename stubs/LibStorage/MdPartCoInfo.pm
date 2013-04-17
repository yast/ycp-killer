package LibStorage::MdPartCoInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_d_get => ["function", "any", "any"],
        swig_d_set => ["function", "void", "any", "any"],
        swig_type_get => ["function", "integer", "any"],
        swig_type_set => ["function", "void", "any", "integer"],
        swig_nr_get => ["function", "integer", "any"],
        swig_nr_set => ["function", "void", "any", "integer"],
        swig_parity_get => ["function", "integer", "any"],
        swig_parity_set => ["function", "void", "any", "integer"],
        swig_uuid_get => ["function", "string", "any"],
        swig_uuid_set => ["function", "void", "any", "string"],
        swig_sb_ver_get => ["function", "string", "any"],
        swig_sb_ver_set => ["function", "void", "any", "string"],
        swig_chunkSizeK_get => ["function", "integer", "any"],
        swig_chunkSizeK_set => ["function", "void", "any", "integer"],
        swig_devices_get => ["function", "string", "any"],
        swig_devices_set => ["function", "void", "any", "string"],
        swig_spares_get => ["function", "string", "any"],
        swig_spares_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_d_get {}
sub swig_d_set {}
sub swig_type_get {}
sub swig_type_set {}
sub swig_nr_get {}
sub swig_nr_set {}
sub swig_parity_get {}
sub swig_parity_set {}
sub swig_uuid_get {}
sub swig_uuid_set {}
sub swig_sb_ver_get {}
sub swig_sb_ver_set {}
sub swig_chunkSizeK_get {}
sub swig_chunkSizeK_set {}
sub swig_devices_get {}
sub swig_devices_set {}
sub swig_spares_get {}
sub swig_spares_set {}
1;
