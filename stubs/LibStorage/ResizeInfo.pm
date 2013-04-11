package LibStorage::ResizeInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_df_freeK_get => ["function", "integer", "any"],
        swig_df_freeK_set => ["function", "void", "any", "integer"],
        swig_resize_freeK_get => ["function", "integer", "any"],
        swig_resize_freeK_set => ["function", "void", "any", "integer"],
        swig_usedK_get => ["function", "integer", "any"],
        swig_usedK_set => ["function", "void", "any", "integer"],
        swig_resize_ok_get => ["function", "boolean", "any"],
        swig_resize_ok_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_df_freeK_get {}
sub swig_df_freeK_set {}
sub swig_resize_freeK_get {}
sub swig_resize_freeK_set {}
sub swig_usedK_get {}
sub swig_usedK_set {}
sub swig_resize_ok_get {}
sub swig_resize_ok_set {}
1;
