#!/bin/bash

source scripts/utils.sh echo -n

# Saner programming env: these switches turn some bugs into errors
set -o errexit -o pipefail

# This script is meant to be used with the command 'datalad run'

wget -O README.txt "http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/README.txt"
files_url=(
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/SHREC16/all.csv all.csv"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02691156.zip 02691156.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02747177.zip 02747177.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02773838.zip 02773838.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02801938.zip 02801938.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02808440.zip 02808440.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02818832.zip 02818832.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02828884.zip 02828884.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02834778.zip 02834778.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02843684.zip 02843684.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02858304.zip 02858304.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02871439.zip 02871439.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02876657.zip 02876657.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02880940.zip 02880940.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02924116.zip 02924116.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02933112.zip 02933112.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02942699.zip 02942699.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02946921.zip 02946921.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02954340.zip 02954340.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02958343.zip 02958343.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/02992529.zip 02992529.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03001627.zip 03001627.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03046257.zip 03046257.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03085013.zip 03085013.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03207941.zip 03207941.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03211117.zip 03211117.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03261776.zip 03261776.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03325088.zip 03325088.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03337140.zip 03337140.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03467517.zip 03467517.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03513137.zip 03513137.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03593526.zip 03593526.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03624134.zip 03624134.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03636649.zip 03636649.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03642806.zip 03642806.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03691459.zip 03691459.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03710193.zip 03710193.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03759954.zip 03759954.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03761084.zip 03761084.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03790512.zip 03790512.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03797390.zip 03797390.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03928116.zip 03928116.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03938244.zip 03938244.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03948459.zip 03948459.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/03991062.zip 03991062.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04004475.zip 04004475.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04074963.zip 04074963.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04090263.zip 04090263.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04099429.zip 04099429.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04225987.zip 04225987.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04256520.zip 04256520.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04330267.zip 04330267.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04379243.zip 04379243.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04401088.zip 04401088.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04460130.zip 04460130.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04468005.zip 04468005.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04530566.zip 04530566.zip"
	"http://shapenet.cs.stanford.edu/shapenet/obj-zip/ShapeNetCore.v1/04554684.zip 04554684.zip")

# These urls require login cookies to download the file
git-annex addurl --fast -c annex.largefiles=anything --raw --batch --with-files <<EOF
$(for file_url in "${files_url[@]}" ; do echo "${file_url}" ; done)
EOF
git-annex get --fast -J8
git-annex migrate --fast -c annex.largefiles=anything *

md5sum all.csv *.zip > md5sums
