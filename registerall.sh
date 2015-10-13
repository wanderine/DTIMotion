#!/bin/bash

for v in {2..275} 
do

	echo "Processing volume $v "

	RegisterTwoVolumes data/b10000_gradient${v}_with_small_affine_motion.nii data/b10000_gradient${v}_reference.nii 

done

fslmerge -t b10000_aligned_linear.nii data/b10000_gradient*_with_small_affine_motion_aligned_linear.nii

fslmerge -t b10000_with_small_affine_motion.nii data/b10000_gradient*_with_small_affine_motion.nii

