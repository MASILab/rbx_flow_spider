
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
- report.html
- report.pdf

**Bundles**
- *_cleaned.trk

**Centroids**
- *_centroids.trk

### Input assumptions and parameters choice
Tractograms from Tractoflow should have at least 500k streamlines each
RecobundlesX is robust to lesions/tumors IF the tractography was adapted for the situation
nb_run is between 1 and 27
vote_ratio is between 0 and 1
