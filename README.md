
# rbx_flow_spider
RBX Flow Spider from XNAT

RecobundlesX is a multi-atlas, multi-parameters version of Recobundles [1, 2]. It is optimized for whole brain coverage using 39 major well-known white matter pathways. The atlas is a customized population average from 20 UKBioBank [3] and 20 Human Connectome Project [4] datasets co-registered to MNI152 space.

This atlas was made to cover as much spatial extend as possible and explore as much shape variability as possible. Recobundles is when run 27 times with bundle-specific paramters and the results of each execution are used in a majority-vote approach. This is inspired from the state-of-the-art in medical images segmentation (before machine-learning) [5,6].

Then, a shape-based pruning is applied to each bundle to remove inconsistent or spurious streamlines (outliers) [7].
See https://zenodo.org/record/4630660# for more details.

    [1] Garyfallidis, Eleftherios, et al. "Recognition of white matter bundles using local and global
        streamline-based registration and clustering." NeuroImage 170 (2018): 283-295.

    [2] Rheault, François. "Analyse et reconstruction de faisceaux de la matière blanche." Computer Science
        (Université de Sherbrooke) (2020), https://savoirs.usherbrooke.ca/handle/11143/17255

    [3] Sudlow, Cathie, et al. "UK biobank: an open access resource for identifying the causes of a wide range of complex
        diseases of middle and old age." Plos med 12.3 (2015): e1001779.

    [4] Van Essen, David C., et al. "The WU-Minn human connectome project: an overview." Neuroimage 80 (2013): 62-79.

    [5] Iglesias, Juan Eugenio, and Mert R. Sabuncu. "Multi-atlas segmentation of biomedical images: a survey."
        Medical image analysis 24.1 (2015): 205-219.

    [6] Pipitone, Jon, et al. "Multi-atlas segmentation of the whole hippocampus and subfields using multiple automatically
        generated templates." Neuroimage 101 (2014): 494-512.

    [7] Côté, Marc-Alexandre, et al. "Cleaning up the mess: tractography outlier removal using hierarchical QuickBundles
        clustering." 23rd ISMRM annual meeting. Toronto, Canada. 2015.


### Inputs
- fa.nii.gz (from Tractoflow)
- local_tracking.trk (from Tractoflow)
- pft_tracking.trk (from Tractoflow)

### Parameters
- nb_run: 27
- vote_ratio: 0.5


### Outputs
**Reporting**
- readme.txt
- report.html
- report.pdf

**DWI**
- dwi.bval
- dwi.bvec
- dwi_resampled.nii.gz
- b0_mask_resampled.nii.gz
- b0_resampled.nii.gz

**DTI_mtrics**
- fa.nii.gz
- md.nii.gz
- rd.nii.gz
- ad.nii.gz
- rgb.nii.gz
- tensor.nii.gz
- evals_e1.nii.gz
- evecs_v1.nii.gz

**FODF_metrics**
- fodf.nii.gz
- peaks.nii.gz
- nufo.nii.gz
- afd_max.nii.gz
- afd_sum.nii.gz
- afd_total.nii.gz

**Register T1w**
- t1_mask_warped.nii.gz
- t1_warped.nii.gz
- output0GenericAffine.mat
- output1InverseWarp.nii.gz
- output1Warp.nii.gz

**Tissue segmentation**
- mask_csf.nii.gz
- mask_gm.nii.gz
- mask_wm.nii.gz
- map_csf.nii.gz
- map_gm.nii.gz
- map_wm.nii.gz

**Tractography masks**
- map_exclude.nii.gz
- map_include.nii.gz
- interface.nii.gz
- local_seeding_mask.nii.gz
- local_tracking_mask.nii.gz
- pft_seeding_mask.nii.gz

**Tracking**
- local_tracking_*.trk
- pft_tracking_*.trk

### Input assumptions and parameters choice

 1. The diffusion has been preprocessed using the dtiQA_v7 pipeline.
 2. The parameters *dti_shells* and *fodf_shells* must be chosen according to each project's sequence. It can be single-shell or multi-shell. 
 3. The acquisition is adequate for tensor reconstruction, 800 < BVAL < 1200, with at least 12 directions.
 4. The acquistion is adequate for fODF reconstruction, 800 < BVAL < 3000, with at least 32 directions.
 5. The parameters *sh_order* (default: 8) is the order of spherical harmonics used for fODF. If your fodf_shells has less than 45 directions, used 6.
 6. *pft_mask_type* and *local_mask_type* (default: wm) defines the initialization "tissue" for tractography. If there is a chance for lesions and tissue segmentation is likely to fail, we recommand switching to fa.
 7. *pft_seed* and *local_seed* (default: 10) define the number of streamlines to initialize per voxel of white matter (or fa).
 8. If tracking is not desired or will be performed outside of the spider, use the smallest values possible (1). 
 9. The *algo* parameter is the choice of tractography algorithm (probabilistic). It is recommanded for most situation, if you want deterministic tractography switch to det.
