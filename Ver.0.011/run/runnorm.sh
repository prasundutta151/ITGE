#############################################################################
## THE  SHELL SCRIPT FOR SETTING UP THE VARIABLES
############################################################################# 
EXP=5

if (( "$#" == $EXP ))
then
    echo "USAGE: sh runreal.sh <ITGE> <VISFILE> <MASKFILE> <REALI>"
    echo 
    exit 1
fi


ITGE=$1
VISFILE=$2
MASKFILE=$3
REALI=$4

echo $ITGE $VISFILE $MASKFILE $REALI
echo
echo

cp $VISFILE ./real/gauss_Vis_${REALI}.FITS
status=$(echo $?)
echo "STATUS = $status"
if (( $status != 0 ))
then
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo "ERROR in copying"
    echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    echo
    exit 1
else
    echo "Run successful"
    echo "***********************************************"
fi


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

code="input.grf ./real/gauss_${REALI}.fits"
run_funcs "grf"


code="./real/gauss_${REALI}.fits $VISFILE  0."
run_funcs "visfitsgrid" 

code="./real/gauss_Vis_${REALI}.FITS ./real/grid_vis_${REALI}.FITS input.gridfits"
run_funcs "gridvisfits"

code="./real/grid_vis_${REALI}.FITS ./real/Image_${REALI}.fits 7"
run_funcs "image"

code="$MASKFILE ./real/MaskU_${REALI}.FITS 3"
run_funcs "rimage"

code="./real/MaskU_${REALI}.FITS 4"
run_funcs "wt2"

code="./real/MaskU_${REALI}.FITS $MASKFILE 4"
run_funcs "image"

code="./real/Image_${REALI}.fits $MASKFILE ./real/MaskImg_${REALI}.fits 7"
run_funcs "multiply"

code="./real/MaskImg_${REALI}.fits ./real/MaskImg_U_${REALI}.FITS 7"
run_funcs "image"

code="./real/MaskImg_U_${REALI}.FITS  ./real/MaskImg_UB_${REALI}.fits"
run_funcs "imgps"





#1. grf input.grf gauss_$REAL.fits
#2. visfitsgrid gauss_$REAL.fits gauss_$REAL_Vis.FITS 0.
#3. Repeat all above steps.
#4. avgmg_img tmp/Mg(prefix to MaskImg_UB file) Norm_vis.FITS 128
#5. binimgps MaskImg_UB.FITS  Norm_vis.FITS input.binimgps Powerspec.pow

