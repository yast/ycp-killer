package LibStorage::ContainerInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_type_get => ["function", "integer", "any"],
        swig_type_set => ["function", "void", "any", "integer"],
        swig_device_get => ["function", "string", "any"],
        swig_device_set => ["function", "void", "any", "string"],
        swig_name_get => ["function", "string", "any"],
        swig_name_set => ["function", "void", "any", "string"],
        swig_udevPath_get => ["function", "string", "any"],
        swig_udevPath_set => ["function", "void", "any", "string"],
        swig_udevId_get => ["function", "string", "any"],
        swig_udevId_set => ["function", "void", "any", "string"],
        swig_usedBy_get => ["function", ["list", "any"], "any"],
        swig_usedBy_set => ["function", "void", "any", ["list", "any"]],
        swig_usedByType_get => ["function", "integer", "any"],
        swig_usedByType_set => ["function", "void", "any", "integer"],
        swig_usedByDevice_get => ["function", "string", "any"],
        swig_usedByDevice_set => ["function", "void", "any", "string"],
        swig_readonly_get => ["function", "boolean", "any"],
        swig_readonly_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_type_get {}
sub swig_type_set {}
sub swig_device_get {}
sub swig_device_set {}
sub swig_name_get {}
sub swig_name_set {}
sub swig_udevPath_get {}
sub swig_udevPath_set {}
sub swig_udevId_get {}
sub swig_udevId_set {}
sub swig_usedBy_get {}
sub swig_usedBy_set {}
sub swig_usedByType_get {}
sub swig_usedByType_set {}
sub swig_usedByDevice_get {}
sub swig_usedByDevice_set {}
sub swig_readonly_get {}
sub swig_readonly_set {}
1;
