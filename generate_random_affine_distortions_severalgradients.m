
clear all
clc
close all

addpath('/home/andek/Research_projects/nifti_matlab/')

bstring = '10000';

% Load DTI data
data = load_untouch_nii(['data/Markus/b_' bstring '.nii']);
volumes = double(data.img);

data = load_untouch_nii(['data/Markus/ref_' bstring '.nii']);
references = double(data.img);

voxel_size_x = data.hdr.dime.pixdim(2);
voxel_size_y = data.hdr.dime.pixdim(3);
voxel_size_z = data.hdr.dime.pixdim(4);

[sy sx sz st] = size(volumes)

%%
% Create random affine transformations, for testing

for motion = 2:2
    
    generated_DTI_volumes = zeros(size(volumes));
    generated_DTI_volumes(:,:,:,1) = volumes(:,:,:,1);    
    
    x_translations = zeros(st,1);
    y_translations = zeros(st,1);
    z_translations = zeros(st,1);
    
    Rotation_matrices = zeros(st,9);
    
    if motion == 1
        matrixfactor = 0.015; % standard deviation for random translations and rotations
        translationfactor = 0.4;
    elseif motion == 2
        matrixfactor = 0.01; % standard deviation for random translations and rotations
        translationfactor = 0.2;
    end
    
    [xi, yi, zi] = meshgrid(-(sx-1)/2:(sx-1)/2,-(sy-1)/2:(sy-1)/2, -(sz-1)/2:(sz-1)/2);
       
    % Loop over timepoints
    for t = 2:st
        
        reference_volume = volumes(:,:,:,t);
        
        t
        
        middle_x = (sx-1)/2;
        middle_y = (sy-1)/2;
        middle_z = (sz-1)/2;
        
        % Translation in 3 directions
        x_translation = translationfactor*randn; % voxels
        y_translation = translationfactor*randn; % voxels
        z_translation = translationfactor*randn; % voxels
        
        x_translations(t) = x_translation;
        y_translations(t) = y_translation;
        z_translations(t) = z_translation;
        
        Rotation_matrix = [1 0 0; 0 1 0; 0 0 1];
        Rotation_matrix = Rotation_matrix + randn(3,3)*matrixfactor;
        Rotation_matrix = Rotation_matrix(:);
        Rotation_matrices(t,:) = Rotation_matrix(:);
        
        rx_r = zeros(sy,sx,sz);
        ry_r = zeros(sy,sx,sz);
        rz_r = zeros(sy,sx,sz);
        
        rx_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(1:3);
        ry_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(4:6);
        rz_r(:) = [xi(:) yi(:) zi(:)]*Rotation_matrix(7:9);
        
        rx_t = zeros(sy,sx,sz);
        ry_t = zeros(sy,sx,sz);
        rz_t = zeros(sy,sx,sz);
        
        rx_t(:) = x_translation;
        ry_t(:) = y_translation;
        rz_t(:) = z_translation;
        
        % Add rotation and translation at the same time
        altered_volume = interp3(xi,yi,zi,reference_volume,rx_r-rx_t,ry_r-ry_t,rz_r-rz_t,'cubic');
        % Remove 'not are numbers' from interpolation
        altered_volume(isnan(altered_volume)) = 0;
        
        generated_DTI_volumes(:,:,:,t) = altered_volume;
        
        % Save testing dataset as nifti file
        new_file = data;
        new_file.hdr = data.hdr;
        new_file.hdr.dime.dim = [3 sy sx sz 1 1 1 1];
        new_file.hdr.dime.pixdim = [1 1.5000 1.5000 1.5000 1 0 0 0];
        new_file.hdr.dime.datatype = 16;
        new_file.hdr.dime.bitpix = 32;
        new_file.img = single(altered_volume);
        if motion == 1
            filename = ['data/b' bstring '_gradient' num2str(t) '_with_large_affine_motion.nii'];
        else
            filename = ['data/b' bstring '_gradient' num2str(t) '_with_small_affine_motion.nii'];
        end
        save_untouch_nii(new_file,filename);
        
        new_file.img = single(references(:,:,:,t));
        filename = ['data/b' bstring '_gradient' num2str(t) '_reference.nii'];
        save_untouch_nii(new_file,filename);
            
    end
                    
    %if motion == 1
    %    filename=['data/simulated_directions_true_large_affine_parameters'];
    %else
    %    filename=['data/simulated_directions_true_small_affine_parameters'];
    %end
    %save(filename,'x_translations','y_translations','z_translations','Rotation_matrices');            
    
end


