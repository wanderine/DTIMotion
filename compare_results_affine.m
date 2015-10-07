%--------------------------------------------------------------------------------
% This script compares estimated motion parameters to true ones,
% for SPM, FSL, AFNI and BROCCOLI
%--------------------------------------------------------------------------------

clear all
close all
clc

basepath_SPM = '/home/andek/Research_projects/DTIMotion/SPM';
basepath_FSL = '/home/andek/Research_projects/DTIMotion/FSL';
basepath_AFNI = '/home/andek/Research_projects/DTIMotion/AFNI';
basepath_BROCCOLI = '/home/andek/Research_projects/DTIMotion/BROCCOLI';
basepath_none = '/home/andek/Research_projects/DTIMotion/data';

bstring = '1000';

amount = 'small';

st = 200;

% load original data
data = load_untouch_nii(['data/b' bstring '.nii']);
original_volume = double(data.img);
[sy sx sz] = size(original_volume);

%-----------------------------------------------------------------
% FSL 
%-------------------------------------------------------------------

% data = load_untouch_nii(['FSL/b1000_with_small_affine_motion_eddy.nii.gz']);
% FSL_corrected_volumes = double(data.img);
% 
% FSL_error = 0;
% 
% for t = 1:st
%     volume = FSL_corrected_volumes(:,:,:,t);
%     FSL_error = FSL_error + sum((volume(:) - original_volume(:)).^2);    
% end
%FSL_error/(sx*sy*sz*st)

%-------------------------------------------------------------------
% BROCCOLI 
%-------------------------------------------------------------------

data = load_untouch_nii(['data/b1000_with_small_affine_motion_aligned_linear.nii']);
BROCCOLI_corrected_volumes = double(data.img);

BROCCOLI_error = 0;

for t = 1:st
    volume = BROCCOLI_corrected_volumes(:,:,:,t);
    %figure(1)
    %imagesc((volume(:,:,50) - original_volume(:,:,50)) / max(original_volume(:)) ); colormap gray; colorbar; drawnow
    BROCCOL_error = BROCCOLI_error + sum((volume(:) - original_volume(:)).^2);    
end
BROCCOL_error/(sx*sy*sz*st)


