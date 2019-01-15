#LINKLIB=  -L/home/samir/astro/lib  -fopenmp -lfftw3 -lcfitsio -lm -lgsl -lgslcblas
LINKLIB=-lfftw3 -lcfitsio -lm -lgsl -lgslcblas
INCLUDE=


exec=gridvisfits collapse image multiply rimage window wt2 imgps binimgps avgmg_img binimg Mask_Gen grf Im2Vis
#visfitsgrid
#Gen_NReal

turget=${exec}

gridvisfits: gridvisfits.c fitsprog.c read_fits_func.c
	gcc -o gridvisfits $(INCLUDE) fitsprog.c read_fits_func.c gridvisfits.c $(LINKLIB)
	rm -rf *~

collapse: collapse.c fitsprog.c
	gcc -o collapse $(INCLUDE) fitsprog.c collapse.c $(LINKLIB)
	rm -rf *~

image: image.c fitsprog.c
	gcc -o image $(INCLUDE) fitsprog.c image.c $(LINKLIB)
	rm -rf *~
multiply: multiply.c
	gcc -o multiply $(INCLUDE) multiply.c $(LINKLIB)
	rm -rf *~

rimage: rimage.c fitsprog.c
	gcc -o rimage $(INCLUDE) fitsprog.c rimage.c $(LINKLIB)
	rm -rf *~

window: window.c fitsprog.c func.c
	gcc -o window $(INCLUDE) fitsprog.c window.c func.c $(LINKLIB)
	rm -rf *~

wt2:    wt2.c
	gcc -o wt2 $(INCLUDE) wt2.c $(LINKLIB)
	rm -rf *~
imgps:imgps.c fitsprog.c
	gcc -o imgps $(INCLUDE) fitsprog.c imgps.c $(LINKLIB)
	rm -rf *~

avgmg_img:avgmg_img.c fitsprog.c
	gcc -o avgmg_img $(INCLUDE) fitsprog.c avgmg_img.c $(LINKLIB)
	rm -rf *~

binimgps: binimgps.c fitsprog.c
	gcc -o binimgps $(INCLUDE) fitsprog.c binimgps.c $(LINKLIB)
	rm -rf *~

binimg: binimg.c fitsprog.c
	gcc -o binimg $(INCLUDE) fitsprog.c binimg.c $(LINKLIB)
	rm -rf *~

Mask_Gen: Mask_Gen.c
	gcc -o Mask_Gen Mask_Gen.c ${LINKLIB}
visfitsgrid: visfitsgrid.c fitsprog.c read_fits_func.c
	gcc -o visfitsgrid visfitsgrid.c fitsprog.c read_fits_func.c ${LINKLIB}


grf: grf.c 
	gcc -o grf grf.c  ${LINKLIB}

#Gen_NReal: Gen_NReal,c
#	gcc -o Gen_NReal Gen_NReal.c -fopenmp -lm

Im2Vis: Im2Vis.c
	gcc -o Im2Vis Im2Vis.c ${LINKLIB}
all:
	make ${exec}
	mv ${exec} ../bin/

clean:
	rm gridvisfits collapse image window rimage wt2 multiply imgps binimgps avgmg_img binimg
