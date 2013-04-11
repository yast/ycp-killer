package LibStorage::DmPartCoInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_d_get => ["function", "any", "any"],
        swig_d_set => ["function", "void", "any", "any"],
        swig_devices_get => ["function", "string", "any"],
        swig_devices_set => ["function", "void", "any", "string"],
        swig_minor_get => ["function", "integer", "any"],
        swig_minor_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_d_get {}
sub swig_d_set {}
sub swig_devices_get {}
sub swig_devices_set {}
sub swig_minor_get {}
sub swig_minor_set {}
1;
