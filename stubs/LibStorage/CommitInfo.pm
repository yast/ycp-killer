package LibStorage::CommitInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_destructive_get => ["function", "boolean", "any"],
        swig_destructive_set => ["function", "void", "any", "boolean"],
        swig_text_get => ["function", "string", "any"],
        swig_text_set => ["function", "void", "any", "string"],
    );
}

sub new {}
sub swig_destructive_get {}
sub swig_destructive_set {}
sub swig_text_get {}
sub swig_text_set {}
1;
