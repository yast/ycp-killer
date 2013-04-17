package LibStorage::ContVolInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_ctype_get => ["function", "integer", "any"],
        swig_ctype_set => ["function", "void", "any", "integer"],
        swig_cname_get => ["function", "string", "any"],
        swig_cname_set => ["function", "void", "any", "string"],
        swig_cdevice_get => ["function", "string", "any"],
        swig_cdevice_set => ["function", "void", "any", "string"],
        swig_vname_get => ["function", "string", "any"],
        swig_vname_set => ["function", "void", "any", "string"],
        swig_vdevice_get => ["function", "string", "any"],
        swig_vdevice_set => ["function", "void", "any", "string"],
        swig_num_get => ["function", "integer", "any"],
        swig_num_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_ctype_get {}
sub swig_ctype_set {}
sub swig_cname_get {}
sub swig_cname_set {}
sub swig_cdevice_get {}
sub swig_cdevice_set {}
sub swig_vname_get {}
sub swig_vname_set {}
sub swig_vdevice_get {}
sub swig_vdevice_set {}
sub swig_num_get {}
sub swig_num_set {}
1;
