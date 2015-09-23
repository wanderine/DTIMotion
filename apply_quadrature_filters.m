close all
clear all
clc

addpath('/home/andek/Research_projects/nifti_matlab/')

directions = 5;

% Load mask
mask = load_untouch_nii('data/mask.nii');
mask = double(mask.img);

% Load DTI data
data = load_untouch_nii('data/b0.nii');
volume = double(data.img);
volume = volume - min(volume(:));
[sy sx sz] = size(volume);

load quadrature_filters.mat

filter_responses = zeros([size(volume),directions]);

disp('Calculating filter responses')
for filter = 1:directions
    filter
    filter_responses(:,:,:,filter) = real(convn(volume,getdata(f{filter}),'same')) + volume/10;
end

write = 1;

% Save testing dataset as nifti file
if write == 1
    new_file = data;
    new_file.hdr = data.hdr;
    new_file.hdr.dime.dim = [4 sy sx sz directions 1 1 1];
    new_file.hdr.dime.datatype = 16;
    new_file.hdr.dime.bitpix = 32;
    new_file.img = single(filter_responses);
    filename = ['data/simulated_directions.nii'];
    save_untouch_nii(new_file,filename);
end

