package LibStorage::VolumeInfo;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        swig_sizeK_get => ["function", "integer", "any"],
        swig_sizeK_set => ["function", "void", "any", "integer"],
        swig_major_get => ["function", "integer", "any"],
        swig_major_set => ["function", "void", "any", "integer"],
        swig_minor_get => ["function", "integer", "any"],
        swig_minor_set => ["function", "void", "any", "integer"],
        swig_name_get => ["function", "string", "any"],
        swig_name_set => ["function", "void", "any", "string"],
        swig_device_get => ["function", "string", "any"],
        swig_device_set => ["function", "void", "any", "string"],
        swig_mount_get => ["function", "string", "any"],
        swig_mount_set => ["function", "void", "any", "string"],
        swig_crypt_device_get => ["function", "string", "any"],
        swig_crypt_device_set => ["function", "void", "any", "string"],
        swig_mount_by_get => ["function", "integer", "any"],
        swig_mount_by_set => ["function", "void", "any", "integer"],
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
        swig_ignore_fstab_get => ["function", "boolean", "any"],
        swig_ignore_fstab_set => ["function", "void", "any", "boolean"],
        swig_fstab_options_get => ["function", "string", "any"],
        swig_fstab_options_set => ["function", "void", "any", "string"],
        swig_uuid_get => ["function", "string", "any"],
        swig_uuid_set => ["function", "void", "any", "string"],
        swig_label_get => ["function", "string", "any"],
        swig_label_set => ["function", "void", "any", "string"],
        swig_mkfs_options_get => ["function", "string", "any"],
        swig_mkfs_options_set => ["function", "void", "any", "string"],
        swig_tunefs_options_get => ["function", "string", "any"],
        swig_tunefs_options_set => ["function", "void", "any", "string"],
        swig_loop_get => ["function", "string", "any"],
        swig_loop_set => ["function", "void", "any", "string"],
        swig_dtxt_get => ["function", "string", "any"],
        swig_dtxt_set => ["function", "void", "any", "string"],
        swig_encryption_get => ["function", "integer", "any"],
        swig_encryption_set => ["function", "void", "any", "integer"],
        swig_crypt_pwd_get => ["function", "string", "any"],
        swig_crypt_pwd_set => ["function", "void", "any", "string"],
        swig_fs_get => ["function", "integer", "any"],
        swig_fs_set => ["function", "void", "any", "integer"],
        swig_detected_fs_get => ["function", "integer", "any"],
        swig_detected_fs_set => ["function", "void", "any", "integer"],
        swig_format_get => ["function", "boolean", "any"],
        swig_format_set => ["function", "void", "any", "boolean"],
        swig_create_get => ["function", "boolean", "any"],
        swig_create_set => ["function", "void", "any", "boolean"],
        swig_is_mounted_get => ["function", "boolean", "any"],
        swig_is_mounted_set => ["function", "void", "any", "boolean"],
        swig_resize_get => ["function", "boolean", "any"],
        swig_resize_set => ["function", "void", "any", "boolean"],
        swig_ignore_fs_get => ["function", "boolean", "any"],
        swig_ignore_fs_set => ["function", "void", "any", "boolean"],
        swig_origSizeK_get => ["function", "integer", "any"],
        swig_origSizeK_set => ["function", "void", "any", "integer"],
    );
}

sub new {}
sub swig_sizeK_get {}
sub swig_sizeK_set {}
sub swig_major_get {}
sub swig_major_set {}
sub swig_minor_get {}
sub swig_minor_set {}
sub swig_name_get {}
sub swig_name_set {}
sub swig_device_get {}
sub swig_device_set {}
sub swig_mount_get {}
sub swig_mount_set {}
sub swig_crypt_device_get {}
sub swig_crypt_device_set {}
sub swig_mount_by_get {}
sub swig_mount_by_set {}
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
sub swig_ignore_fstab_get {}
sub swig_ignore_fstab_set {}
sub swig_fstab_options_get {}
sub swig_fstab_options_set {}
sub swig_uuid_get {}
sub swig_uuid_set {}
sub swig_label_get {}
sub swig_label_set {}
sub swig_mkfs_options_get {}
sub swig_mkfs_options_set {}
sub swig_tunefs_options_get {}
sub swig_tunefs_options_set {}
sub swig_loop_get {}
sub swig_loop_set {}
sub swig_dtxt_get {}
sub swig_dtxt_set {}
sub swig_encryption_get {}
sub swig_encryption_set {}
sub swig_crypt_pwd_get {}
sub swig_crypt_pwd_set {}
sub swig_fs_get {}
sub swig_fs_set {}
sub swig_detected_fs_get {}
sub swig_detected_fs_set {}
sub swig_format_get {}
sub swig_format_set {}
sub swig_create_get {}
sub swig_create_set {}
sub swig_is_mounted_get {}
sub swig_is_mounted_set {}
sub swig_resize_get {}
sub swig_resize_set {}
sub swig_ignore_fs_get {}
sub swig_ignore_fs_set {}
sub swig_origSizeK_get {}
sub swig_origSizeK_set {}
1;
