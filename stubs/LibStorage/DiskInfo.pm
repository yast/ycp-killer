package LibStorage::DiskInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_sizeK_get => ["function", "integer", "any"],
        swig_sizeK_set => ["function", "void", "any", "integer"],
        swig_cylSize_get => ["function", "integer", "any"],
        swig_cylSize_set => ["function", "void", "any", "integer"],
        swig_cyl_get => ["function", "integer", "any"],
        swig_cyl_set => ["function", "void", "any", "integer"],
        swig_heads_get => ["function", "integer", "any"],
        swig_heads_set => ["function", "void", "any", "integer"],
        swig_sectors_get => ["function", "integer", "any"],
        swig_sectors_set => ["function", "void", "any", "integer"],
        swig_sectorSize_get => ["function", "integer", "any"],
        swig_sectorSize_set => ["function", "void", "any", "integer"],
        swig_disklabel_get => ["function", "string", "any"],
        swig_disklabel_set => ["function", "void", "any", "string"],
        swig_orig_disklabel_get => ["function", "string", "any"],
        swig_orig_disklabel_set => ["function", "void", "any", "string"],
        swig_maxPrimary_get => ["function", "integer", "any"],
        swig_maxPrimary_set => ["function", "void", "any", "integer"],
        swig_extendedPossible_get => ["function", "boolean", "any"],
        swig_extendedPossible_set => ["function", "void", "any", "boolean"],
        swig_maxLogical_get => ["function", "integer", "any"],
        swig_maxLogical_set => ["function", "void", "any", "integer"],
        swig_initDisk_get => ["function", "boolean", "any"],
        swig_initDisk_set => ["function", "void", "any", "boolean"],
        swig_transport_get => ["function", "integer", "any"],
        swig_transport_set => ["function", "void", "any", "integer"],
        swig_has_fake_partition_get => ["function", "boolean", "any"],
        swig_has_fake_partition_set => ["function", "void", "any", "boolean"],
        swig_iscsi_get => ["function", "boolean", "any"],
        swig_iscsi_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_sizeK_get {}
sub swig_sizeK_set {}
sub swig_cylSize_get {}
sub swig_cylSize_set {}
sub swig_cyl_get {}
sub swig_cyl_set {}
sub swig_heads_get {}
sub swig_heads_set {}
sub swig_sectors_get {}
sub swig_sectors_set {}
sub swig_sectorSize_get {}
sub swig_sectorSize_set {}
sub swig_disklabel_get {}
sub swig_disklabel_set {}
sub swig_orig_disklabel_get {}
sub swig_orig_disklabel_set {}
sub swig_maxPrimary_get {}
sub swig_maxPrimary_set {}
sub swig_extendedPossible_get {}
sub swig_extendedPossible_set {}
sub swig_maxLogical_get {}
sub swig_maxLogical_set {}
sub swig_initDisk_get {}
sub swig_initDisk_set {}
sub swig_transport_get {}
sub swig_transport_set {}
sub swig_has_fake_partition_get {}
sub swig_has_fake_partition_set {}
sub swig_iscsi_get {}
sub swig_iscsi_set {}
1;
