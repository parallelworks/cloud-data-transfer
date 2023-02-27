#!/bin/bash
#=============================
# Plot results from run_all_aws_test.sh
#
# Provide a file name.
#=============================

infile=$1

# Set test type
# (sync -> using aws sync)
# (pacp -> explicit parallel copy)
test_type=$2

# Grab data
grep $test_type $infile > tmp.raw

# Plot simple data transfer rates (MB/s)
awk '{print $2, $3, $9}' tmp.raw > tmp.ul.xyz
awk '{print $2, $3, $12}' tmp.raw > tmp.dl.xyz

# Normalize transfer rate (MB/s) by total amount of MB transfered
# (Skipped because these tests are currently run on a single node.
# Normalization may be worth exploring for multi-node benchmarks
# Also, for this case, set a lower limit on the color bar, 0.1
# instead of 1 in makecpt, below.)
#awk '{print $2, $3, $9/$6}' tmp.raw > tmp.ul.xyz
#awk '{print $2, $3, $12/$6}' tmp.raw > tmp.dl.xyz

# Set domain
# (Could do this automatically...)
xmin=1
xmax=1000
ymin=1
ymax=1000
rflag="-R"${xmin}/${xmax}/${ymin}/${ymax}

bflag="-B"a100g10/a100g10WsEn

# Interpolate

# Make colortable
gmt makecpt -T1/200/25 -Cno_green > tmp.cpt

# Plot UL speeds

#gmt psbasemap $rflag -JX3i/3i -Bf25a100 -Bx+l"Number of files" -By+l"Size of each file [MB]" -BWeSn -P -K > tmp.ps

gmt psbasemap $rflag -JX3il/3il -Bxa1+l"Number of files" -Bya1+l"Size of each file [MB]" -BWeSn -P -K -Y2i > tmp.ps
gmt pscontour tmp.ul.xyz -R -I -Ctmp.cpt -J -P -O -K >> tmp.ps
gmt pscontour tmp.ul.xyz -R -Ctmp.cpt -J -P -O -K -Wthick,black >> tmp.ps
gmt psxy tmp.ul.xyz -R -J -P -O -K -Sc0.1 -Gblack -Wblack >> tmp.ps

# Plot DL speeds
gmt psbasemap $rflag -JX3il/3il -Bxa1+l"Number of files" -Bya1 -BWeSn -P -O -K -Y0i -X4i >> tmp.ps
gmt pscontour tmp.dl.xyz -R -I -Ctmp.cpt -J -P -O -K >> tmp.ps
gmt pscontour tmp.dl.xyz -R -Ctmp.cpt -J -P -O -K -Wthick,black >> tmp.ps
gmt psxy tmp.dl.xyz -R -J -P -O -K -Sc0.1 -Gblack -Wblack >> tmp.ps

# Plot colorbar
gmt psscale -Dx-4i/-1i+w7i/0.25i+e+h -Ctmp.cpt -Ba1+l"Upload or download data transfer rate [MB/s]" -Q -P -O -K >> tmp.ps

# Clean up
rm -f tmp.raw
rm -f tmp.cpt
rm -f tmp.ul.xyz
rm -f tmp.dl.xyz
ps2pdf tmp.ps
rm -f tmp.ps
mv tmp.pdf ${infile}.${test_type}.pdf
