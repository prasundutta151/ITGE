#different dimension in grf.c and other .c progs in img_estimator
ITGE=../
export path
export path1

vis.FITS: Input Visibility Fits file
Mask.fits: Input Image Mask fits file (same geometry as Image.fits, first and second have same mask values)
MaskU.fits: Input Visibility Mask fits file
Win_Im.fits: Windows on image plane
Win_Vis.FITS: Windows on visibiity plane
grid_vis.FITS: Gridded visibility
Image.fits: Image fits file
MaskImg.fits: Image with mask multiplied
MaskImg_U.FITS: Gridded visibilities for the MaskImg.fits.
MaskImg_UB.FITS: Gridded unbiased visibility square

$ITGE/bin/gridvisfits vis.FITS grid_vis.FITS input.gridfits
$ITGE/bin/image grid_vis.FITS Image.fits 7
$ITGE/bin/rimage Mask.fits MaskU.FITS 3
$ITGE/bin/wt2 tmp/MaskU.FITS 4  
$ITGE/bin/image tmp/MaskU.FITS tmp/Mask.fits 4
$ITGE/bin/multiply tmp/Image.fits Mask.fits MaskImg.fits 7  
$ITGE/bin/rimage MaskImg.fits MaskImg_U.FITS 7
$ITGE/bin/imgps  MaskImg_U.FITS  MaskImg_UB.FITS

Following files can be deleted at the end of the run:
rm -rf grid_vis.FITS Image.fits MaskU.FITS MaskImg.fits 
The file Mask.fits is needed for the realization loop.

===============
For normalization:

1. grf input.grf gauss_$REAL.fits
2. visfitsgrid gauss_$REAL.fits gauss_$REAL_Vis.FITS 0.
3. Repeat all above steps.
4. avgmg_img tmp/Mg(prefix to MaskImg_UB file) Norm_vis.FITS 128
5. binimgps MaskImg_UB.FITS  Norm_vis.FITS input.binimgps Powerspec.pow

