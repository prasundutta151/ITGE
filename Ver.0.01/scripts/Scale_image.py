import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import sys
import pyfits
import os.path
from scipy.ndimage.filters import *
import numpy.ma as ma
from numpy.random import *
import scipy.ndimage.interpolation as intp

def FITS_READ(infile):

    file   = pyfits.open(infile)
    data   = file[0].data
    header = file[0].header
    dxy    = header['CDELT2']
    NGrid  = header['naxis1']
    ddim   = len(data.shape)
    data   = data.reshape(NGrid, NGrid) 

    return data, NGrid, dxy

def FITS_WRITE(outfile, data, dxy, BMaj, BMin):

    hdu = pyfits.PrimaryHDU(data)
    hdulist = pyfits.HDUList([hdu])
    hdulist[0].header['CDELT1'] = dxy
    hdulist[0].header['CDELT2'] = dxy
    hdulist[0].header['BMAJ']   = BMaj
    hdulist[0].header['BMIN']   = BMin
    hdulist.writeto(outfile)
    
DTR = np.pi/180.
EXP_NARG=3

if(len(sys.argv)!=EXP_NARG):
    print
    print "USAGE: python/run", sys.argv[0], "<SETUPFILE> <INPMASK>"

    print "SETUPFILE: Setup file"
    print "DELIFILE: FITS File with Mask"
    sys.exit()

SETUPFILE = sys.argv[1]
INPMASK = sys.argv[2]

if(os.path.exists(SETUPFILE)==False):
    print "\nWARNING: File %s does not Exists\n" %SETUPFILE
    sys.exit(0)
if(os.path.exists(INPMASK)==False):
    print "\nWARNING: File %s does not Exists\n" %INPMASK
    sys.exit(0)

data = np.loadtxt(SETUPFILE, dtype=np.str)
data = data.T[0]
binpath = data[0]
projdir = data[1]
MASKFILE  = binpath + projdir + '/tmp/' + data[3]

if(os.path.exists(MASKFILE)):
    print "\nWARNING: File %s Exists, not created again\n" %MASKFILE
    sys.exit(0)


dataI, NGridI, dxyI = FITS_READ(INPMASK)
'''
inputfile = binpath + projdir + '/' + 'input.gridfits'
data = np.loadtxt(inputfile, dtype=np.str)
'''
NGrid = 2002
dxy = 3.434312458E-02
zratio = dxy/dxyI

dataO = np.zeros((NGridI, NGridI))
dataO= intp.zoom(input=dataI, zoom=zratio, order=3, mode='constant', cval=0.0, prefilter=True)/zratio**2
 
'''
dataO = dataI*dataC
FITS_WRITE("delI.fits", dataO, dxyO, BMajO, BMinO)



'''
