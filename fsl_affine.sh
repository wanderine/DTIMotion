#!/bin/bash

eddy_correct b1000_with_small_affine_motion.nii FSL/b1000_with_small_affine_motion_eddy.nii 0 &   

eddy_correct b3000_with_small_affine_motion.nii FSL/b3000_with_small_affine_motion_eddy.nii 0 &   

eddy_correct b5000_with_small_affine_motion.nii FSL/b5000_with_small_affine_motion_eddy.nii 0 &   

eddy_correct b10000_with_small_affine_motion.nii FSL/b10000_with_small_affine_motion_eddy.nii 0 &   


