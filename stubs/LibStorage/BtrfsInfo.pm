package LibStorage::BtrfsInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_v_get => ["function", "any", "any"],
        swig_v_set => ["function", "void", "any", "any"],
        swig_devices_get => ["function", "string", "any"],
        swig_devices_set => ["function", "void", "any", "string"],
        swig_devices_add_get => ["function", "string", "any"],
        swig_devices_add_set => ["function", "void", "any", "string"],
        swig_devices_rem_get => ["function", "string", "any"],
        swig_devices_rem_set => ["function", "void", "any", "string"],
        swig_subvol_get => ["function", "string", "any"],
        swig_subvol_set => ["function", "void", "any", "string"],
        swig_subvol_add_get => ["function", "string", "any"],
        swig_subvol_add_set => ["function", "void", "any", "string"],
        swig_subvol_rem_get => ["function", "string", "any"],
        swig_subvol_rem_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_v_get {}
sub swig_v_set {}
sub swig_devices_get {}
sub swig_devices_set {}
sub swig_devices_add_get {}
sub swig_devices_add_set {}
sub swig_devices_rem_get {}
sub swig_devices_rem_set {}
sub swig_subvol_get {}
sub swig_subvol_set {}
sub swig_subvol_add_get {}
sub swig_subvol_add_set {}
sub swig_subvol_rem_get {}
sub swig_subvol_rem_set {}
1;
