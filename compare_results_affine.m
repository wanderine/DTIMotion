%--------------------------------------------------------------------------------
% This script compares estimated motion parameters to true ones,
% for SPM, FSL, AFNI and BROCCOLI
%--------------------------------------------------------------------------------

clear all
close all
clc

addpath('/home/andek/Research_projects/nifti_matlab/')

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
original_volume = original_volume(:,:,10:end-10);
[sy sx sz] = size(original_volume);

%-----------------------------------------------------------------
% FSL 
%-------------------------------------------------------------------

data = load_untouch_nii(['FSL/b' bstring '_with_small_affine_motion_eddy.nii.gz']);
FSL_corrected_volumes = double(data.img);
FSL_corrected_volumes = FSL_corrected_volumes(:,:,10:end-10,:);

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
mean(FSL_error)  / mean(volume(:))
std(FSL_error)
mean(FSL_correlation)
std(FSL_correlation)


%-------------------------------------------------------------------
% BROCCOLI 
%-------------------------------------------------------------------

data = load_untouch_nii(['BROCCOLI/b' bstring '_with_small_affine_motion_aligned_linear.nii']);
BROCCOLI_corrected_volumes = double(data.img);
BROCCOLI_corrected_volumes = BROCCOLI_corrected_volumes(:,:,10:end-10,:);

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
mean(BROCCOLI_error) / mean(volume(:))
std(BROCCOLI_error)
mean(BROCCOLI_correlation)
std(BROCCOLI_correlation)


data = load_untouch_nii(['data/b' bstring '_with_small_affine_motion.nii']);
distorded_volumes = double(data.img);
distorded_volumes = distorded_volumes(:,:,10:end-10,:);

vidObj = VideoWriter('dti_distortion2.avi');
vidObj.FrameRate = 5;
open(vidObj);

set(gca,'nextplot','replacechildren');

for t = 1:st
    figure(1)
    imagesc([ distorded_volumes(:,:,50,t) FSL_corrected_volumes(:,:,50,t) BROCCOLI_corrected_volumes(:,:,50,t) ]); colormap gray    
    title('Distorded   |  FSL corrected  |  BROCCOLI corrected')
    pause(0.15)
    currFrame = getframe;
    writeVideo(vidObj,currFrame);
end
   
close(vidObj);





%------------------
% Several gradients
%------------------

% load original data
data = load_untouch_nii(['data/simulated_directions.nii']);
original_volumes = double(data.img);
original_volumes = original_volumes(:,:,10:end-10,:);
[sy sx sz st] = size(original_volumes);

%-----------------------------------------------------------------
% FSL 
%-------------------------------------------------------------------

data = load_untouch_nii(['FSL/simulated_directions_with_small_affine_motion_eddy.nii.gz']);
FSL_corrected_volumes = double(data.img);
FSL_corrected_volumes = FSL_corrected_volumes(:,:,10:end-10,:);

FSL_error = zeros(st,1);
FSL_correlation = zeros(st,1);
FSL_error_volume = zeros(sy,sx,sz);
for t = 1:st
    original_volume = original_volumes(:,:,:,t);
    volume = FSL_corrected_volumes(:,:,:,t);
    FSL_error(t) = sum((volume(:) - original_volume(:)).^2);    
    FSL_correlation(t) = corr2(volume(:),original_volume(:));
    FSL_error_volume = FSL_error_volume + abs( volume - original_volume );
end
FSL_error = FSL_error/(sx*sy*sz);
mean(FSL_error)  / mean(volume(:))
std(FSL_error)
mean(FSL_correlation)
std(FSL_correlation)


%-------------------------------------------------------------------
% BROCCOLI 
%-------------------------------------------------------------------

data = load_untouch_nii(['BROCCOLI/simulated_directions_with_small_affine_motion_aligned_linear.nii']);
BROCCOLI_corrected_volumes = double(data.img);
BROCCOLI_corrected_volumes = BROCCOLI_corrected_volumes(:,:,10:end-10,:);

BROCCOLI_error = zeros(st,1);
BROCCOLI_correlation = zeros(st,1);
BROCCOLI_error_volume = zeros(sy,sx,sz);
for t = 1:st
    original_volume = original_volumes(:,:,:,t);
    volume = BROCCOLI_corrected_volumes(:,:,:,t);
    BROCCOLI_error(t) = sum((volume(:) - original_volume(:)).^2);    
    BROCCOLI_correlation(t) = corr2(volume(:),original_volume(:));
    BROCCOLI_error_volume = BROCCOLI_error_volume + abs( volume - original_volume );
end
BROCCOLI_error = BROCCOLI_error/(sx*sy*sz);
mean(BROCCOLI_error) / mean(volume(:))
std(BROCCOLI_error)
mean(BROCCOLI_correlation)
std(BROCCOLI_correlation)


