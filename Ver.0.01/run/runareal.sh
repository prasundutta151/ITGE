#############################################################################
## THE  SHELL SCRIPT FOR SETTING UP THE VARIABLES
############################################################################# 
EXP=4

if (( "$#" == $EXP ))
then
    echo "USAGE: sh runreal.sh <ITGE> <VISFILE> <MASKFILE>"
    echo 
    exit 1
fi


ITGE=$1
VISFILE=$2
MASKFILE=$3

echo $ITGE $VISFILE $MASKFILE
echo
echo

run_funcs(){

srname=$1
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

code="./tmp/MaskImg.fits ./tmp/MaskImg_U.FITS 7"
run_funcs "image"

code="./tmp/MaskImg_U.FITS  ./tmp/MaskImg_UB.FITS"
run_funcs "imgps"




