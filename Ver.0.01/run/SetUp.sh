#############################################################################
## THE  SHELL SCRIPT FOR SETTING UP THE VARIABLES
############################################################################# 
EXP=1

if (( "$#" != $EXP ))
then
    echo "USAGE: sh SetUp.sh <Inputfile> "
    echo 
    exit 1
fi

INPFILE=$1

ITGE=$(grep "Location" $INPFILE | awk {'print $1}')
PROJDIR=$(grep "PROJDIR" $INPFILE | awk {'print $1}')
VISFILE=$(grep "VISF" $INPFILE | awk {'print $1}')
MASKFILE=$(grep "MASKF" $INPFILE | awk {'print $1}')
NORMFILE=$(grep "NORMF" $INPFILE | awk {'print $1}')
POWFILE=$(grep "POWF" $INPFILE | awk {'print $1}')

PROJDIR=$ITGE/$PROJDIR
mkdir -p $PROJDIR

VISFILE=$PROJDIR/$VISFILE
MASKFILE=$PROJDIR/$MASKFILE
NORMFILE=$PROJDIR/$NORMFILE
POWFILE=$PROJDIR/$POWFILE

INPGRF=input.grf
INPGVF=input.gridfits
INPBIN=input.binimgps

cd $ITGE/run
cp $INPGRF $INPGVF $INPBIN $PROJDIR

export ITGE PROJDIR VISFILE NORMFILE POWFILE INPGRF INPGVF INPBIN

echo "Parameter setup complete."
echo "Project directory is $PROJDIR"
cat  $PROJDIR/$INPGRF $PROJDIR/$INPGVF $PROJDIR/$INPBIN

echo
echo
echo "Modify these files before proceeding."
echo
echo


echo $ITGE $PROJDIR $VISFILE $NORMFILE $POWFILE $INPGRF $INPGVF $INPBIN


$ITGE/bin/gridvisfits $VISFITS ./tmp/grid_vis.FITS input.gridfits
$ITGE/bin/image ./tmp/grid_vis.FITS ./tmp/Image.fits 7
$ITGE/bin/rimage Mask.fits ./tmp/MaskU.FITS 3
$ITGE/bin/wt2 ./tmp/MaskU.FITS 4  
$ITGE/bin/image ./tmp/MaskU.FITS Mask.fits 4
$ITGE/bin/multiply ./tmp/Image.fits Mask.fits ./MaskImg.fits 7  
$ITGE/bin/rimage ./MaskImg.fits ./MaskImg_U.FITS 7
$ITGE/bin/imgps  ./MaskImg_U.FITS  ./MaskImg_UB.FITS

