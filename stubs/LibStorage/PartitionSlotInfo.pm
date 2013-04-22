package LibStorage::PartitionSlotInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_cylStart_get => ["function", "integer", "any"],
        swig_cylStart_set => ["function", "void", "any", "integer"],
        swig_cylSize_get => ["function", "integer", "any"],
        swig_cylSize_set => ["function", "void", "any", "integer"],
        swig_primarySlot_get => ["function", "boolean", "any"],
        swig_primarySlot_set => ["function", "void", "any", "boolean"],
        swig_primaryPossible_get => ["function", "boolean", "any"],
        swig_primaryPossible_set => ["function", "void", "any", "boolean"],
        swig_extendedSlot_get => ["function", "boolean", "any"],
        swig_extendedSlot_set => ["function", "void", "any", "boolean"],
        swig_extendedPossible_get => ["function", "boolean", "any"],
        swig_extendedPossible_set => ["function", "void", "any", "boolean"],
        swig_logicalSlot_get => ["function", "boolean", "any"],
        swig_logicalSlot_set => ["function", "void", "any", "boolean"],
        swig_logicalPossible_get => ["function", "boolean", "any"],
        swig_logicalPossible_set => ["function", "void", "any", "boolean"],
    );
}

sub new {}
sub swig_cylStart_get {}
sub swig_cylStart_set {}
sub swig_cylSize_get {}
sub swig_cylSize_set {}
sub swig_primarySlot_get {}
sub swig_primarySlot_set {}
sub swig_primaryPossible_get {}
sub swig_primaryPossible_set {}
sub swig_extendedSlot_get {}
sub swig_extendedSlot_set {}
sub swig_extendedPossible_get {}
sub swig_extendedPossible_set {}
sub swig_logicalSlot_get {}
sub swig_logicalSlot_set {}
sub swig_logicalPossible_get {}
sub swig_logicalPossible_set {}
1;
