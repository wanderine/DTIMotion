
clear all
clc
close all

addpath('/home/andek/Research_projects/nifti_matlab/')

for bfactor = 1:4
    
    if bfactor == 1
        bstring = '1000'
    elseif bfactor == 2
        bstring = '3000'
    elseif bfactor == 3
        bstring = '5000'
    elseif bfactor == 4
        bstring = '10000'
    end
    
    % Load DTI data
    data = load_untouch_nii(['data/b' bstring '.nii']);
    volume = double(data.img);
    
    voxel_size_x = data.hdr.dime.pixdim(2);
    voxel_size_y = data.hdr.dime.pixdim(3);
    voxel_size_z = data.hdr.dime.pixdim(4);
    
    [sy sx sz] = size(volume)
    st = 200;
    
    %%
    % Create random rigid transformations, for testing
    
    for motion = 2:2
        
        generated_DTI_volumes = zeros([size(volume),st]);
        generated_DTI_volumes(:,:,:,1) = volume;
        reference_volume = volume;
        
        x_translations = zeros(st,1);
        y_translations = zeros(st,1);
        z_translations = zeros(st,1);
        
        x_rotations = zeros(st,1);
        y_rotations = zeros(st,1);
        z_rotations = zeros(st,1);        
        
        if motion == 1
            factor = 0.4; % standard deviation for random translations and rotations
        elseif motion == 2
            factor = 0.2; % standard deviation for random translations and rotations
        end
        
        [xi, yi, zi] = meshgrid(-(sx-1)/2:(sx-1)/2,-(sy-1)/2:(sy-1)/2, -(sz-1)/2:(sz-1)/2);
        
        % Loop over timepoints
        for t = 2:st
            
            t
            
            middle_x = (sx-1)/2;
            middle_y = (sy-1)/2;
            middle_z = (sz-1)/2;
            
            % Translation in 3 directions
            x_translation = factor*randn; % voxels
            y_translation = factor*randn; % voxels
            z_translation = factor*randn; % voxels
            
            x_translations(t) = x_translation;
            y_translations(t) = y_translation;
            z_translations(t) = z_translation;
            
            % Rotation in 3 directions
            x_rotation = factor*randn; % degrees
            y_rotation = factor*randn; % degrees
            z_rotation = factor*randn; % degrees
            
            x_rotations(t) = x_rotation;
            y_rotations(t) = y_rotation;
            z_rotations(t) = z_rotation;
            
            % Create rotation matrices around the three axes
            
            R_x = [1                        0                           0;
                0                        cos(x_rotation*pi/180)      -sin(x_rotation*pi/180);
                0                        sin(x_rotation*pi/180)      cos(x_rotation*pi/180)];
            
            R_y = [cos(y_rotation*pi/180)   0                           sin(y_rotation*pi/180);
                0                        1                           0;
                -sin(y_rotation*pi/180)  0                           cos(y_rotation*pi/180)];
            
            R_z = [cos(z_rotation*pi/180)   -sin(z_rotation*pi/180)     0;
                sin(z_rotation*pi/180)   cos(z_rotation*pi/180)      0;
                0                        0                           1];
            
            Rotation_matrix = R_x * R_y * R_z;
            Rotation_matrix = Rotation_matrix(:);
            
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
            
        end
        
        % Save testing dataset as nifti file
        new_file = data;
        new_file.hdr = data.hdr;
        new_file.hdr.dime.dim = [4 sy sx sz st 1 1 1];
        new_file.hdr.dime.pixdim = [1 1.5000 1.5000 1.5000 2 0 0 0];
        new_file.hdr.dime.datatype = 16;
        new_file.hdr.dime.bitpix = 32;
        new_file.img = single(generated_DTI_volumes);
        if motion == 1
            filename = ['data/b' bstring '_with_large_rigid_motion.nii'];
        else
            filename = ['data/b' bstring '_with_small_rigid_motion.nii'];
        end
        save_untouch_nii(new_file,filename);
        
        %%
        
        if motion == 1
            filename=['data/b' bstring '_true_large_rigid_parameters'];
        else
            filename=['data/b' bstring '_true_small_rigid_parameters'];
        end
        save(filename,'x_translations','y_translations','z_translations','x_rotations','y_rotations','z_rotations');
        
    end
    
end
