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

data = load_untouch_nii(['data/b' bstring '_with_small_affine_motion_eddy.nii.gz']);
FSL_corrected_volumes = double(data.img);

FSL_error = zeros(st,1);
FSL_correlation = zeros(st,1);
FSL_error_volume = zeros(sy,sx,sz);
for t = 1:st
    volume = FSL_corrected_volumes(:,:,:,t);
    FSL_error(t) = sum((volume(:) - original_volume(:)).^2);    
    FSL_correlation(t) = corr2(volume(:),original_volume(:));
    FSL_error_volume = FSL_error_volume + abs( volume - original_volume );
end
FSL_error = FSL_error/(sx*sy*sz);
mean(FSL_error)
std(FSL_error)
mean(FSL_correlation)
std(FSL_correlation)


%-------------------------------------------------------------------
% BROCCOLI 
%-------------------------------------------------------------------

data = load_untouch_nii(['data/b' bstring '_with_small_affine_motion_aligned_linear.nii']);
BROCCOLI_corrected_volumes = double(data.img);

BROCCOLI_error = zeros(st,1);
BROCCOLI_correlation = zeros(st,1);
BROCCOLI_error_volume = zeros(sy,sx,sz);
for t = 1:st
    volume = BROCCOLI_corrected_volumes(:,:,:,t);
    %figure(1)
    %imagesc((volume(:,:,50) - original_volume(:,:,50)) / max(original_volume(:)) ); colormap gray; colorbar; drawnow
    BROCCOLI_error(t) = sum((volume(:) - original_volume(:)).^2);    
    BROCCOLI_correlation(t) = corr2(volume(:),original_volume(:));
    BROCCOLI_error_volume = BROCCOLI_error_volume + abs( volume - original_volume );
end
BROCCOLI_error = BROCCOLI_error/(sx*sy*sz);
mean(BROCCOLI_error)
std(BROCCOLI_error)
mean(BROCCOLI_correlation)
std(BROCCOLI_correlation)



for t = 1:st
    figure(1)
    imagesc([ FSL_corrected_volumes(:,:,50,t) BROCCOLI_corrected_volumes(:,:,50,t) ]); colormap gray    
    pause(0.15)
end
    
figure
image([ FSL_error_volume(:,:,50)/500 BROCCOLI_error_volume(:,:,50)/500 ]); colormap gray

var(FSL_corrected_volumes(:))
var(BROCCOLI_corrected_volumes(:))

