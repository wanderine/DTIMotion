#!/bin/bash

3dvolreg -prefix temp1 -1Dfile b1000_with_small_rigid_motion_motionparameters.1D b1000_with_small_rigid_motion.nii &

3dvolreg -prefix temp2 -1Dfile b3000_with_small_rigid_motion_motionparameters.1D b3000_with_small_rigid_motion.nii &

3dvolreg -prefix temp3 -1Dfile b5000_with_small_rigid_motion_motionparameters.1D b5000_with_small_rigid_motion.nii &

3dvolreg -prefix temp4 -1Dfile b10000_with_small_rigid_motion_motionparameters.1D b10000_with_small_rigid_motion.nii &

