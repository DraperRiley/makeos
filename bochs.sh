BOCHSCONF=bochs_config
BOCHS=bochs

make clean
make
$BOCHS -f $BOCHSCONF
