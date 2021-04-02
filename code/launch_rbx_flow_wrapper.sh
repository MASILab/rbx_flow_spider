#!/bin/bash

# Prepare input for Tractoflow
IN_DIR=${1}
OUT_DIR=${2}
N_SUBJ=${3}
N_SESS=${4}
IN_FA=${5}
IN_TRACKING_LOCAL=${6}
IN_TRACKING_PFT=${7}

cd /TMP/
mkdir raw/${N_SUBJ}_${N_SESS} -p
cp ${IN_DIR}/${IN_FA} raw/${N_SUBJ}_${N_SESS}/fa.nii.gz
scil_streamlines_math.py concatenate ${IN_DIR}/${IN_TRACKING_LOCAL} ${IN_DIR}/${IN_TRACKING_PFT} raw/${N_SUBJ}_${N_SESS}/tracking.trk

# Relevant parameters for Tractoflow
NB_RUN=${8}
VOTE_RATIO=${9}

/nextflow /rbx_flow/main.nf \
	--input raw/ --atlas_config /rbx_pop_average/config.json --atlas_anat /rbx_pop_average/mni_masked.nii.gz \
	--atlas_directory /rbx_pop_average/atlas/ --atlas_centroids /rbx_pop_average/centroids/ \
	--multi_parameters ${NB_RUN} --minimal_vote_ratio ${VOTE_RATIO} --wb_clustering_thr "8 10 12" \
	--register_processes 1 --rbx_processes 1 --processes 1 -resume -with-report report.html

xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_bundles_mosaic.py raw/${N_SUBJ}_${N_SESS}/fa.nii.gz \
	results_rbx/*/Clean_Bundles/*_L_cleaned.trk  left.png --resolution_of_thumbnails 300 --opacity_background 0.5 -f --zoom 1.5
xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_bundles_mosaic.py raw/${N_SUBJ}_${N_SESS}/fa.nii.gz \
	results_rbx/*/Clean_Bundles/*_R_cleaned.trk  right.png --resolution_of_thumbnails 300 --opacity_background 0.5 -f --zoom 1.5
xvfb-run -a --server-num=$((65536+$$)) --server-args="-screen 0 1600x1280x24 -ac" \
	scil_visualize_bundles_mosaic.py raw/${N_SUBJ}_${N_SESS}/fa.nii.gz \
	results_rbx/*/Clean_Bundles/*__CC_*_cleaned.trk results_rbx/*/Clean_Bundles/*__MCP_cleaned.trk comm.png \
	--resolution_of_thumbnails 300 --opacity_background 0.5 -f --zoom 1.5

# convert pft.png -crop 600x3600+600+0 pft.png
# convert local.png -crop 600x3600+600+0 local.png

python3.7 /CODE/generate_rbx_flow_spider_pdf.py ${N_SUBJ}_${N_SESS} 

cp report.pdf report.html results_rbx/*/readme.txt ${OUT_DIR}/
cp -L results_rbx/*/Clean_Bundles/*.trk ${OUT_DIR}/
cp -L results_rbx/*/Transform_Centroids/*.trk ${OUT_DIR}/
