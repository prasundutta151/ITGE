#different dimension in grf.c and other .c progs in img_estimator
path="/data2/samir/img_tge/img_tge_NGC/diffmulti"
path1="/home/samir/simulation2/img_estimator/srcbin"
export path
export path1

N=128

#sh run1.sh
#sh run2.sh

for i in `seq 1 $N`;
do
    :'
    sed "s/-850/-2$i"56"/" input.grf >input.grfcp
    $path/grf input.grfcp tmp/img.FITS

    ./REAL/3D2DMulti_Fits tmp/img.FITS REAL/NGC628_1arcmin_Win.FITS tmp/imgwin.FITS 1.
    rm -rf tmp/img.FITS
    mv tmp/imgwin.FITS tmp/img.FITS
 
    #cp visnsedata_imgtge/vis1.03nse$i.fits visnse.FITS
    #$path/visfitsgrid tmp/img.FITS visnse.FITS 1.
    #$path1/gridvisfits visnse.FITS tmp/tmp.FITS input.gridfits

    $path/visfitsgrid tmp/img.FITS vis.FITS 0.
    ./REAL/Arith_Fits vis.FITS 1. 1.3 -${i}
 
    $path1/gridvisfits vis.FITS tmp/tmp.FITS input.gridfits
    #$path1/gridvisfits ./REAL/NGC628_VISMOM0$i.FITS tmp/tmp.FITS input.gridfits
    #$path1/gridvisfits NGC628_VISMOM0.FITS tmp/tmp.FITS input.gridfits

    $path1/collapse tmp/tmp.FITS tmp/tmpcollp.FITS
    #$path1/image tmp/tmpcollp.FITS tmp/SIdiff$i.fits 7
    $path1/image tmp/tmpcollp.FITS tmp/SIdiffgalaxy$i.fits 7
    '  
    #theta_w is the radius in arcmin
    #$path1/window tmp/SIdiff$i.fits tmp/SW.fits 3 95.
    #$path1/rimage tmp/SW.fits tmp/BW.FITS 3
    #$path1/wt2 tmp/BW.FITS 4
    #$path1/image tmp/BW.FITS tmp/SW.fits 4
  
    #$path1/multiply tmp/SIdiff$i.fits tmp/SW.fits tmp/SIW.FITS 7
    $path1/multiply tmp/SIdiffgalaxy$i.fits tmp/SW_bw7.5_3.5_n4.fits tmp/SIW.FITS 7
    $path1/rimage tmp/SIW.FITS tmp/BIW.FITS 7
    
    #$path1/imgps tmp/BIW.FITS tmp/Mg$i.fits

    $path1/imgps tmp/BIW.FITS tmp/GVdiff$i.FITS
    #$path1/binimgps tmp/GVdiff$i.FITS input.binimgps tmp/powerspec_diff$i.dat avgMg.fits
    $path1/binimgps tmp/GVdiff$i.FITS input.binimgps tmp/powerspec_diff$i.dat avgMg_bw7.5_3.5_n4.fits
       
    #$path1/binimg tmp/BIW.FITS input.binimgps tmp/powerspec_diff$i.dat
    
    rm -rf tmp/*FITS
    #rm visnse.FITS
    #rm -rf tmp/SIdiff$i.fits
done

#rm vis.FITS
#$path1/avgmg_img tmp/Mg avgMg.fits 128

./psavg $N 20 powerspecavg_diffgalaxybw7.5_3.5_n4.dat

#rm -rf tmp/Mg*
rm -rf tmp/powerspec_diff*
#mv tmp/SW.fits tmp/SW_gauss91.fits
#mv avgMg.fits avgMg_gauss91.fits