
clear all
clc
close all

addpath('/home/andek/Research_projects/spm8/')
data_path = '/home/andek/Research_projects/DTIMotion/SPM';
results_directory = '/home/andek/Research_projects/DTIMotion/SPM/';

bstring = '3000';
motion = 'small';

try
    system(['rm' ' batch_preprocessing.mat']);
end
    
N = 1;

% Loop over subjects

tic
for s = 1:N
    
    
    %% Initialise SPM defaults
    %--------------------------------------------------------------------------
    spm('Defaults','fMRI');
    spm_jobman('initcfg'); 
    
    
    %% WORKING DIRECTORY (useful for .ps only)
    %--------------------------------------------------------------------------
    clear pjobs
    pjobs{1}.util{1}.cdir.directory = cellstr(data_path);                      
    
    %filename = [data_path '/b' bstring '_with_' motion '_rigid_motion.nii'];    
    %subject = ['b' bstring '_with_' motion '_rigid_motion.nii']; 
    
    filename = [data_path '/simulated_directions_with_small_rigid_motion.nii'];    
    subject = ['simulated_directions_with_small_rigid_motion.nii']; 
    
    %% Motion correction settings
    
    % Set data to use
    pjobs{2}.spatial{1}.realign{1}.estwrite.data{1} = cellstr(filename);
    
    % Register to first volume
    pjobs{2}.spatial{1}.realign{1}.estwrite.eoptions.rtm = 0;      
        
    % 2nd degree B-spline for estimation (default)
    pjobs{2}.spatial{1}.realign{1}.estwrite.eoptions.interp = 2;     
    % 4th degree B-spline interpolation for reslice (default)
    pjobs{2}.spatial{1}.realign{1}.estwrite.roptions.interp = 4;          
    
    % Only reslice images, not mean
    pjobs{2}.spatial{1}.realign{1}.estwrite.roptions.which = [2 0];

    save('batch_preprocessing.mat','pjobs');
        
    error1 = 0;
    start = clock;
    try        
        % Run preprocessing        
        spm_jobman('run',pjobs);                
    catch err
        err
        error1 = 1;
    end
    
    % Move files to results directory 
    
    motion_corrected_data = ['r' subject ];
    motion_corrected_matrix = ['r' subject(1:end-4) '.mat' ];
    motion_parameters = ['rp_' subject(1:end-4) '.txt'];    
        
    new_motion_corrected_data = ['r' subject(1:end-4)  '.nii'];
    new_motion_corrected_matrix = ['r' subject(1:end-4) '.mat' ];
    new_motion_parameters = ['rp_' subject(1:end-4) '.txt'];    
    mat = [subject(1:end-4) '.mat'];
    
    system(['mv ' motion_corrected_data ' ' results_directory new_motion_corrected_data]);
    system(['mv ' motion_corrected_matrix ' ' results_directory new_motion_corrected_matrix]);
    system(['mv ' motion_parameters ' ' results_directory new_motion_parameters]);    
    system(['rm ' mat]);
            
    try
        system(['rm' ' batch_preprocessing.mat']);
    end
    
end
toc








