#############################################################################
## THE  SHELL SCRIPT FOR SETTING UP THE VARIABLES
############################################################################# 
EXP=3

if (( "$#" != $EXP ))
then
    echo "USAGE: sh SetUp.sh <Inputfile> <NREAL> <NTHREAD>"
    echo 
    exit 1
fi

INPFILE=$1
NREAL=$2
NTHREAD=$3

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

rm -rf tmp real $NORMFILE
mkdir -p tmp
mkdir -p real
sh ../../run/runareal.sh $ITGE $VISFILE $MASKFILE 


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

#code="$ITGE/run/runnorm.sh $NREAL $NTHREAD $ITGE $VISFILE $MASKFILE"
#run_funcs "Gen_NReal"

for (( ii=0; ii<$NREAL; ii=$ii+1 ))
do
    echo "Doing for realization $ii"
    sh  $ITGE/run/runnorm.sh $ITGE  $VISFILE $MASKFILE $ii
done

code="./real/MaskImg_UB_ $NORMFILE $NREAL"
run_funcs "avgmg_img"

code="./tmp/MaskImg_UB.FITS  $NORMFILE input.binimgps $POWFILE"
run_funcs binimgps 
