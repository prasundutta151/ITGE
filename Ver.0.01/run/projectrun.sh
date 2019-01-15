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
echo $ITGE $PROJDIR $VISFILE 
echo
echo $NORMFILE $POWFILE $INPGRF $INPGVF $INPBIN
echo
cd $PROJDIR

rm -rf tmp
mkdir -p tmp

run_funcs(){

srname=$1
echo $code
echo "*************************************************"
echo "Running $srname"
echo "$ITGE/bin/$srname $code"
echo "*************************************************"
$ITGE/bin/$srname $code
status=$(echo $?)
if (( $status != 0 ))
then
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo "ERROR in $srname"
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo
    exit 1
else
    echo "Run successful"
    echo "***********************************************"
fi
}

code="$VISFILE ./tmp/grid_vis.FITS input.gridfits"
run_funcs "gridvisfits"

code="./tmp/grid_vis.FITS ./tmp/Image.fits 7"
run_funcs "image"

code="$MASKFILE ./tmp/MaskU.FITS 3"
run_funcs "rimage"

code="./tmp/MaskU.FITS 4"
run_funcs "wt2"

code="./tmp/MaskU.FITS $MASKFILE 4"
run_funcs "image"

code="./tmp/Image.fits $MASKFILE ./tmp/MaskImg.fits 7"
run_funcs "multiply"

code="./tmp/MaskImg.fits ./MaskImg_U.FITS 7"
run_funcs "image"

code="./tmp/MaskImg_U.FITS  ./MaskImg_UB.FITS"
run_funcs "imgps"

rm -rf tmp


