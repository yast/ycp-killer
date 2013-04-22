package LibStorage::UsedByInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string", "integer", "&string"],
        swig_type_get => ["function", "integer", "any"],
        swig_type_set => ["function", "void", "any", "integer"],
        swig_device_get => ["function", "string", "any"],
        swig_device_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_type_get {}
sub swig_type_set {}
sub swig_device_get {}
sub swig_device_set {}
1;
