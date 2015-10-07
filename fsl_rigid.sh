#!/bin/bash

mcflirt -in b1000_with_small_rigid_motion.nii -refvol 0 -plots &   

mcflirt -in b3000_with_small_rigid_motion.nii -refvol 0 -plots &   

mcflirt -in FSL/b5000_with_small_rigid_motion.nii -refvol 0 -plots &   

mcflirt -in FSL/b10000_with_small_rigid_motion.nii -refvol 0 -plots &   


