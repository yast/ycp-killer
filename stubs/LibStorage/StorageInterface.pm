package LibStorage::StorageInterface;
BEGIN {
    %TYPEINFO = (
        ALL_METHODS => 0,
        new => ["function", "any", "string"],
        getContainers => ["function", "void", "any", ["&list", "any"]],
        getDiskInfo => ["function", "integer", "any", "&string", "any"],
        getContDiskInfo => ["function", "integer", "any", "&string", "any", "any"],
        getLvmVgInfo => ["function", "integer", "any", "&string", "any"],
        getContLvmVgInfo => ["function", "integer", "any", "&string", "any", "any"],
        getDmraidCoInfo => ["function", "integer", "any", "&string", "any"],
        getContDmraidCoInfo => ["function", "integer", "any", "&string", "any", "any"],
        getDmmultipathCoInfo => ["function", "integer", "any", "&string", "any"],
        getContDmmultipathCoInfo => ["function", "integer", "any", "&string", "any", "any"],
        getMdPartCoInfo => ["function", "integer", "any", "&string", "any"],
        getContMdPartCoInfo => ["function", "integer", "any", "&string", "any", "any"],
        setImsmDriver => ["function", "void", "any", "integer"],
        getImsmDriver => ["function", "integer", "any"],
        setMultipathAutostart => ["function", "void", "any", "integer"],
        getMultipathAutostart => ["function", "integer", "any"],
        getVolumes => ["function", "void", "any", ["&list", "any"]],
        getVolume => ["function", "integer", "any", "&string", "any"],
        getPartitionInfo => ["function", "integer", "any", "&string", ["&list", "any"]],
        getLvmLvInfo => ["function", "integer", "any", "&string", ["&list", "any"]],
        getMdInfo => ["function", "integer", "any", ["&list", "any"]],
        getMdPartInfo => ["function", "integer", "any", "&string", ["&list", "any"]],
        getNfsInfo => ["function", "integer", "any", ["&list", "any"]],
        getLoopInfo => ["function", "integer", "any", ["&list", "any"]],
        getDmInfo => ["function", "integer", "any", ["&list", "any"]],
        getBtrfsInfo => ["function", "integer", "any", ["&list", "any"]],
        getTmpfsInfo => ["function", "integer", "any", ["&list", "any"]],
        getDmraidInfo => ["function", "integer", "any", "&string", ["&list", "any"]],
        getDmmultipathInfo => ["function", "integer", "any", "&string", ["&list", "any"]],
        getFsCapabilities => ["function", "boolean", "any", "integer", "any"],
        getDlabelCapabilities => ["function", "boolean", "any", "&string", "any"],
        getAllUsedFs => ["function", ["list", "string"], "any"],
        createPartition => ["function", "integer", "any", "&string", "integer", "integer", "integer", "&string"],
        resizePartition => ["function", "integer", "any", "&string", "integer"],
        resizePartitionNoFs => ["function", "integer", "any", "&string", "integer"],
        updatePartitionArea => ["function", "integer", "any", "&string", "integer", "integer"],
        freeCylindersAroundPartition => ["function", "integer", "any", "&string", "&integer", "&integer"],
        nextFreePartition => ["function", "integer", "any", "&string", "integer", "&integer", "&string"],
        createPartitionKb => ["function", "integer", "any", "&string", "integer", "integer", "integer", "&string"],
        createPartitionAny => ["function", "integer", "any", "&string", "integer", "&string"],
        createPartitionMax => ["function", "integer", "any", "&string", "integer", "&string"],
        cylinderToKb => ["function", "integer", "any", "&string", "integer"],
        kbToCylinder => ["function", "integer", "any", "&string", "integer"],
        removePartition => ["function", "integer", "any", "&string"],
        changePartitionId => ["function", "integer", "any", "&string", "integer"],
        forgetChangePartitionId => ["function", "integer", "any", "&string"],
        getPartitionPrefix => ["function", "string", "any", "&string"],
        getPartitionName => ["function", "string", "any", "&string", "integer"],
        getUnusedPartitionSlots => ["function", "integer", "any", "&string", ["&list", "any"]],
        destroyPartitionTable => ["function", "integer", "any", "&string", "&string"],
        initializeDisk => ["function", "integer", "any", "&string", "boolean"],
        defaultDiskLabel => ["function", "string", "any", "&string"],
        changeFormatVolume => ["function", "integer", "any", "&string", "boolean", "integer"],
        changeLabelVolume => ["function", "integer", "any", "&string", "&string"],
        changeMkfsOptVolume => ["function", "integer", "any", "&string", "&string"],
        changeTunefsOptVolume => ["function", "integer", "any", "&string", "&string"],
        changeMountPoint => ["function", "integer", "any", "&string", "&string"],
        getMountPoint => ["function", "integer", "any", "&string", "&string"],
        changeMountBy => ["function", "integer", "any", "&string", "integer"],
        getMountBy => ["function", "integer", "any", "&string", "&integer"],
        changeFstabOptions => ["function", "integer", "any", "&string", "&string"],
        getFstabOptions => ["function", "integer", "any", "&string", "&string"],
        addFstabOptions => ["function", "integer", "any", "&string", "&string"],
        removeFstabOptions => ["function", "integer", "any", "&string", "&string"],
        setCryptPassword => ["function", "integer", "any", "&string", "&string"],
        forgetCryptPassword => ["function", "integer", "any", "&string"],
        getCryptPassword => ["function", "integer", "any", "&string", "&string"],
        verifyCryptPassword => ["function", "integer", "any", "&string", "&string", "boolean"],
        needCryptPassword => ["function", "boolean", "any", "&string"],
        setCrypt => ["function", "integer", "any", "&string", "boolean"],
        setCryptType => ["function", "integer", "any", "&string", "boolean", "integer"],
        getCrypt => ["function", "integer", "any", "&string", "&boolean"],
        setIgnoreFstab => ["function", "integer", "any", "&string", "boolean"],
        getIgnoreFstab => ["function", "integer", "any", "&string", "&boolean"],
        changeDescText => ["function", "integer", "any", "&string", "&string"],
        addFstabEntry => ["function", "integer", "any", "&string", "&string", "&string", "&string", "integer", "integer"],
        resizeVolume => ["function", "integer", "any", "&string", "integer"],
        resizeVolumeNoFs => ["function", "integer", "any", "&string", "integer"],
        forgetResizeVolume => ["function", "integer", "any", "&string"],
        setRecursiveRemoval => ["function", "void", "any", "boolean"],
        getRecursiveRemoval => ["function", "boolean", "any"],
        getRecursiveUsing => ["function", "integer", "any", ["&list", "string"], "boolean", ["&list", "string"]],
        getRecursiveUsedBy => ["function", "integer", "any", ["&list", "string"], "boolean", ["&list", "string"]],
        setZeroNewPartitions => ["function", "void", "any", "boolean"],
        getZeroNewPartitions => ["function", "boolean", "any"],
        setPartitionAlignment => ["function", "void", "any", "integer"],
        getPartitionAlignment => ["function", "integer", "any"],
        setDefaultMountBy => ["function", "void", "any", "integer"],
        getDefaultMountBy => ["function", "integer", "any"],
        setDefaultFs => ["function", "void", "any", "integer"],
        getDefaultFs => ["function", "integer", "any"],
        setDefaultSubvolName => ["function", "void", "any", "&string"],
        getDefaultSubvolName => ["function", "string", "any"],
        getEfiBoot => ["function", "boolean", "any"],
        setRootPrefix => ["function", "void", "any", "&string"],
        getRootPrefix => ["function", "string", "any"],
        setDetectMountedVolumes => ["function", "void", "any", "boolean"],
        getDetectMountedVolumes => ["function", "boolean", "any"],
        removeVolume => ["function", "integer", "any", "&string"],
        createLvmVg => ["function", "integer", "any", "&string", "integer", "boolean", ["&list", "string"]],
        removeLvmVg => ["function", "integer", "any", "&string"],
        extendLvmVg => ["function", "integer", "any", "&string", ["&list", "string"]],
        shrinkLvmVg => ["function", "integer", "any", "&string", ["&list", "string"]],
        createLvmLv => ["function", "integer", "any", "&string", "&string", "integer", "integer", "&string"],
        removeLvmLvByDevice => ["function", "integer", "any", "&string"],
        removeLvmLv => ["function", "integer", "any", "&string", "&string"],
        changeLvStripeCount => ["function", "integer", "any", "&string", "&string", "integer"],
        changeLvStripeSize => ["function", "integer", "any", "&string", "&string", "integer"],
        createLvmLvSnapshot => ["function", "integer", "any", "&string", "&string", "&string", "integer", "&string"],
        removeLvmLvSnapshot => ["function", "integer", "any", "&string", "&string"],
        getLvmLvSnapshotStateInfo => ["function", "integer", "any", "&string", "&string", "any"],
        createLvmLvPool => ["function", "integer", "any", "&string", "&string", "integer", "&string"],
        createLvmLvThin => ["function", "integer", "any", "&string", "&string", "&string", "integer", "&string"],
        changeLvChunkSize => ["function", "integer", "any", "&string", "&string", "integer"],
        nextFreeMd => ["function", "integer", "any", "&integer", "&string"],
        createMd => ["function", "integer", "any", "&string", "integer", ["&list", "string"], ["&list", "string"]],
        createMdAny => ["function", "integer", "any", "integer", ["&list", "string"], ["&list", "string"], "&string"],
        removeMd => ["function", "integer", "any", "&string", "boolean"],
        extendMd => ["function", "integer", "any", "&string", ["&list", "string"], ["&list", "string"]],
        updateMd => ["function", "integer", "any", "&string", ["&list", "string"], ["&list", "string"]],
        shrinkMd => ["function", "integer", "any", "&string", ["&list", "string"], ["&list", "string"]],
        changeMdType => ["function", "integer", "any", "&string", "integer"],
        changeMdChunk => ["function", "integer", "any", "&string", "integer"],
        changeMdParity => ["function", "integer", "any", "&string", "integer"],
        checkMd => ["function", "integer", "any", "&string"],
        getMdStateInfo => ["function", "integer", "any", "&string", "any"],
        getMdPartCoStateInfo => ["function", "integer", "any", "&string", "any"],
        computeMdSize => ["function", "integer", "any", "integer", ["&list", "string"], ["&list", "string"], "&integer"],
        getMdAllowedParity => ["function", ["list", "integer"], "any", "integer", "integer"],
        removeMdPartCo => ["function", "integer", "any", "&string", "boolean"],
        addNfsDevice => ["function", "integer", "any", "&string", "&string", "integer", "&string", "boolean"],
        checkNfsDevice => ["function", "integer", "any", "&string", "&string", "boolean", "&integer"],
        createFileLoop => ["function", "integer", "any", "&string", "boolean", "integer", "&string", "&string", "&string"],
        modifyFileLoop => ["function", "integer", "any", "&string", "&string", "boolean", "integer"],
        removeFileLoop => ["function", "integer", "any", "&string", "boolean"],
        removeDmraid => ["function", "integer", "any", "&string"],
        existSubvolume => ["function", "boolean", "any", "&string", "&string"],
        createSubvolume => ["function", "integer", "any", "&string", "&string"],
        removeSubvolume => ["function", "integer", "any", "&string", "&string"],
        extendBtrfsVolume => ["function", "integer", "any", "&string", ["&list", "string"]],
        shrinkBtrfsVolume => ["function", "integer", "any", "&string", ["&list", "string"]],
        addTmpfsMount => ["function", "integer", "any", "&string", "&string"],
        removeTmpfsMount => ["function", "integer", "any", "&string"],
        getCommitInfos => ["function", "void", "any", ["&list", "any"]],
        getLastAction => ["function", "string", "any"],
        getExtendedErrorMessage => ["function", "string", "any"],
        setCacheChanges => ["function", "void", "any", "boolean"],
        isCacheChanges => ["function", "boolean", "any"],
        commit => ["function", "integer", "any"],
        getErrorString => ["function", "string", "any", "integer"],
        createBackupState => ["function", "integer", "any", "&string"],
        restoreBackupState => ["function", "integer", "any", "&string"],
        checkBackupState => ["function", "boolean", "any", "&string"],
        equalBackupStates => ["function", "boolean", "any", "&string", "&string", "boolean"],
        removeBackupState => ["function", "integer", "any", "&string"],
        checkDeviceMounted => ["function", "boolean", "any", "&string", ["&list", "string"]],
        umountDevice => ["function", "boolean", "any", "&string"],
        umountDeviceUns => ["function", "boolean", "any", "&string", "boolean"],
        mountDevice => ["function", "boolean", "any", "&string", "&string"],
        activateEncryption => ["function", "integer", "any", "&string", "boolean"],
        mountDeviceOpts => ["function", "boolean", "any", "&string", "&string", "&string"],
        mountDeviceRo => ["function", "boolean", "any", "&string", "&string", "&string"],
        checkDmMapsTo => ["function", "boolean", "any", "&string"],
        removeDmTableTo => ["function", "void", "any", "&string"],
        renameCryptDm => ["function", "integer", "any", "&string", "&string"],
        getFreeInfo => ["function", "boolean", "any", "&string", "boolean", "any", "boolean", "any", "boolean"],
        readFstab => ["function", "boolean", "any", "&string", ["&list", "any"]],
        activateHld => ["function", "void", "any", "boolean"],
        activateMultipath => ["function", "void", "any", "boolean"],
        rescanEverything => ["function", "void", "any"],
        rescanCryptedObjects => ["function", "boolean", "any"],
        dumpObjectList => ["function", "void", "any"],
        dumpCommitInfos => ["function", "void", "any"],
        getContVolInfo => ["function", "integer", "any", "&string", "any"],
    );
}

sub new {}
sub getContainers {}
sub getDiskInfo {}
sub getContDiskInfo {}
sub getLvmVgInfo {}
sub getContLvmVgInfo {}
sub getDmraidCoInfo {}
sub getContDmraidCoInfo {}
sub getDmmultipathCoInfo {}
sub getContDmmultipathCoInfo {}
sub getMdPartCoInfo {}
sub getContMdPartCoInfo {}
sub setImsmDriver {}
sub getImsmDriver {}
sub setMultipathAutostart {}
sub getMultipathAutostart {}
sub getVolumes {}
sub getVolume {}
sub getPartitionInfo {}
sub getLvmLvInfo {}
sub getMdInfo {}
sub getMdPartInfo {}
sub getNfsInfo {}
sub getLoopInfo {}
sub getDmInfo {}
sub getBtrfsInfo {}
sub getTmpfsInfo {}
sub getDmraidInfo {}
sub getDmmultipathInfo {}
sub getFsCapabilities {}
sub getDlabelCapabilities {}
sub getAllUsedFs {}
sub createPartition {}
sub resizePartition {}
sub resizePartitionNoFs {}
sub updatePartitionArea {}
sub freeCylindersAroundPartition {}
sub nextFreePartition {}
sub createPartitionKb {}
sub createPartitionAny {}
sub createPartitionMax {}
sub cylinderToKb {}
sub kbToCylinder {}
sub removePartition {}
sub changePartitionId {}
sub forgetChangePartitionId {}
sub getPartitionPrefix {}
sub getPartitionName {}
sub getUnusedPartitionSlots {}
sub destroyPartitionTable {}
sub initializeDisk {}
sub defaultDiskLabel {}
sub changeFormatVolume {}
sub changeLabelVolume {}
sub changeMkfsOptVolume {}
sub changeTunefsOptVolume {}
sub changeMountPoint {}
sub getMountPoint {}
sub changeMountBy {}
sub getMountBy {}
sub changeFstabOptions {}
sub getFstabOptions {}
sub addFstabOptions {}
sub removeFstabOptions {}
sub setCryptPassword {}
sub forgetCryptPassword {}
sub getCryptPassword {}
sub verifyCryptPassword {}
sub needCryptPassword {}
sub setCrypt {}
sub setCryptType {}
sub getCrypt {}
sub setIgnoreFstab {}
sub getIgnoreFstab {}
sub changeDescText {}
sub addFstabEntry {}
sub resizeVolume {}
sub resizeVolumeNoFs {}
sub forgetResizeVolume {}
sub setRecursiveRemoval {}
sub getRecursiveRemoval {}
sub getRecursiveUsing {}
sub getRecursiveUsedBy {}
sub setZeroNewPartitions {}
sub getZeroNewPartitions {}
sub setPartitionAlignment {}
sub getPartitionAlignment {}
sub setDefaultMountBy {}
sub getDefaultMountBy {}
sub setDefaultFs {}
sub getDefaultFs {}
sub setDefaultSubvolName {}
sub getDefaultSubvolName {}
sub getEfiBoot {}
sub setRootPrefix {}
sub getRootPrefix {}
sub setDetectMountedVolumes {}
sub getDetectMountedVolumes {}
sub removeVolume {}
sub createLvmVg {}
sub removeLvmVg {}
sub extendLvmVg {}
sub shrinkLvmVg {}
sub createLvmLv {}
sub removeLvmLvByDevice {}
sub removeLvmLv {}
sub changeLvStripeCount {}
sub changeLvStripeSize {}
sub createLvmLvSnapshot {}
sub removeLvmLvSnapshot {}
sub getLvmLvSnapshotStateInfo {}
sub createLvmLvPool {}
sub createLvmLvThin {}
sub changeLvChunkSize {}
sub nextFreeMd {}
sub createMd {}
sub createMdAny {}
sub removeMd {}
sub extendMd {}
sub updateMd {}
sub shrinkMd {}
sub changeMdType {}
sub changeMdChunk {}
sub changeMdParity {}
sub checkMd {}
sub getMdStateInfo {}
sub getMdPartCoStateInfo {}
sub computeMdSize {}
sub getMdAllowedParity {}
sub removeMdPartCo {}
sub addNfsDevice {}
sub checkNfsDevice {}
sub createFileLoop {}
sub modifyFileLoop {}
sub removeFileLoop {}
sub removeDmraid {}
sub existSubvolume {}
sub createSubvolume {}
sub removeSubvolume {}
sub extendBtrfsVolume {}
sub shrinkBtrfsVolume {}
sub addTmpfsMount {}
sub removeTmpfsMount {}
sub getCommitInfos {}
sub getLastAction {}
sub getExtendedErrorMessage {}
sub setCacheChanges {}
sub isCacheChanges {}
sub commit {}
sub getErrorString {}
sub createBackupState {}
sub restoreBackupState {}
sub checkBackupState {}
sub equalBackupStates {}
sub removeBackupState {}
sub checkDeviceMounted {}
sub umountDevice {}
sub umountDeviceUns {}
sub mountDevice {}
sub activateEncryption {}
sub mountDeviceOpts {}
sub mountDeviceRo {}
sub checkDmMapsTo {}
sub removeDmTableTo {}
sub renameCryptDm {}
sub getFreeInfo {}
sub readFstab {}
sub activateHld {}
sub activateMultipath {}
sub rescanEverything {}
sub rescanCryptedObjects {}
sub dumpObjectList {}
sub dumpCommitInfos {}
sub getContVolInfo {}
1;
