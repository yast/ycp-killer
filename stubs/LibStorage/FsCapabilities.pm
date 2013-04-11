package LibStorage::FsCapabilities;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_isExtendable_get => ["function", "boolean", "any"],
        swig_isExtendable_set => ["function", "void", "any", "boolean"],
        swig_isExtendableWhileMounted_get => ["function", "boolean", "any"],
        swig_isExtendableWhileMounted_set => ["function", "void", "any", "boolean"],
        swig_isReduceable_get => ["function", "boolean", "any"],
        swig_isReduceable_set => ["function", "void", "any", "boolean"],
        swig_isReduceableWhileMounted_get => ["function", "boolean", "any"],
        swig_isReduceableWhileMounted_set => ["function", "void", "any", "boolean"],
        swig_supportsUuid_get => ["function", "boolean", "any"],
        swig_supportsUuid_set => ["function", "void", "any", "boolean"],
        swig_supportsLabel_get => ["function", "boolean", "any"],
        swig_supportsLabel_set => ["function", "void", "any", "boolean"],
        swig_labelWhileMounted_get => ["function", "boolean", "any"],
        swig_labelWhileMounted_set => ["function", "void", "any", "boolean"],
        swig_labelLength_get => ["function", "integer", "any"],
        swig_labelLength_set => ["function", "void", "any", "integer"],
        swig_minimalFsSizeK_get => ["function", "integer", "any"],
        swig_minimalFsSizeK_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_isExtendable_get {}
sub swig_isExtendable_set {}
sub swig_isExtendableWhileMounted_get {}
sub swig_isExtendableWhileMounted_set {}
sub swig_isReduceable_get {}
sub swig_isReduceable_set {}
sub swig_isReduceableWhileMounted_get {}
sub swig_isReduceableWhileMounted_set {}
sub swig_supportsUuid_get {}
sub swig_supportsUuid_set {}
sub swig_supportsLabel_get {}
sub swig_supportsLabel_set {}
sub swig_labelWhileMounted_get {}
sub swig_labelWhileMounted_set {}
sub swig_labelLength_get {}
sub swig_labelLength_set {}
sub swig_minimalFsSizeK_get {}
sub swig_minimalFsSizeK_set {}
1;
