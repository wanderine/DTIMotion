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

% Select noise level in data

N = 1;

voxel_size = 1.5;

show_parameters = 0;       % Show the estimated parameters as plots or not, for SPM, FSL, AFNI and BROCCOLI
show_errors = 1;           % Show the motion errors or not, for SPM, FSL, AFNI and BROCCOLI

bstring = '1000';

amount = 'small';

st = 200;

%-----------------------------------------------------------------
% SPM 
%-------------------------------------------------------------------

errors_SPM = zeros(N,1);

dirs = dir([basepath_none]);

% Loop over subjects
for s = 1:N

    s

    % Load estimated motion parameters
    fid = fopen([basepath_SPM '/rp_b' bstring '_with_' amount '_rigid_motion.txt']);
    text = textscan(fid,'%f%f%f%f%f%f');
    fclose(fid);

    transx = text{1};
    transy = text{2};
    transz = text{3};

    rotx = text{4};
    roty = text{5};
    rotz = text{6};

    % Convert parameters to BROCCOLI coordinate system
    SPM_translations_x = transy/voxel_size;
    SPM_translations_y = transx/voxel_size;
    SPM_translations_z = -transz/voxel_size;

    SPM_rotations_x = -roty*180/pi;
    SPM_rotations_y = rotx*180/pi;
    SPM_rotations_z = -rotz*180/pi;

    % Load true parameters
    load([basepath_none '/b' bstring '_true_' amount '_rigid_parameters.mat']);

    % Calculate errors
    errors = zeros(st,6);
    errors(:,1) = SPM_translations_x - x_translations;
    errors(:,2) = SPM_translations_y - y_translations;
    errors(:,3) = SPM_translations_z - z_translations;
    errors(:,4) = SPM_rotations_x - x_rotations;
    errors(:,5) = SPM_rotations_y - y_rotations;
    errors(:,6) = SPM_rotations_z - z_rotations;

    errors_SPM(s) = sqrt(sum(sum(errors.^2)));
end



%-----------------------------------------------------------------
% FSL 
%-------------------------------------------------------------------

errors_FSL = zeros(N,1);

% Loop over subjects
for s = 1:N

    % Load estimated motion parameters
    fid = fopen([basepath_FSL '/b' bstring '_with_' amount '_rigid_motion_mcf.par']);
    text = textscan(fid,'%f%f%f%f%f%f');
    fclose(fid);

    rotx = text{1};
    roty = text{2};
    rotz = text{3};

    transx = text{4};
    transy = text{5};
    transz = text{6};

    % Convert parameters to BROCCOLI coordinate system
    FSL_translations_x = -transy/voxel_size;
    FSL_translations_y = transx/voxel_size;
    FSL_translations_z = -transz/voxel_size;
    FSL_rotations_x = roty*180/pi;
    FSL_rotations_y = -rotx*180/pi;
    FSL_rotations_z = rotz*180/pi;

    % Load true parameters
    load([basepath_none '/b' bstring '_true_' amount '_rigid_parameters.mat']);

    % Calculate errors
    errors = zeros(st,6);
    errors(:,1) = FSL_translations_x - x_translations;
    errors(:,2) = FSL_translations_y - y_translations;
    errors(:,3) = FSL_translations_z - z_translations;
    errors(:,4) = FSL_rotations_x - x_rotations;
    errors(:,5) = FSL_rotations_y - y_rotations;
    errors(:,6) = FSL_rotations_z - z_rotations;

    errors_FSL(s) = sqrt(sum(sum(errors.^2)));
end





%-----------------------------------------------------------------------
% AFNI 
%-------------------------------------------------------------------

errors_AFNI = zeros(N,1);

% Loop over subjects
for s = 1:N

    % Load estimated motion parameters
    fid = fopen([basepath_AFNI '/b' bstring '_with_' amount '_rigid_motion_motionparameters.1D']);
    text = textscan(fid,'%f%f%f%f%f%f');
    fclose(fid);

    roll = text{1};
    pitch = text{2};
    yaw = text{3};

    dS = text{4}; % Superior
    dL = text{5}; % Left
    dP = text{6}; % Posterior

    % Convert parameters to BROCCOLI coordinate system
    AFNI_translations_x = -dP/voxel_size;
    AFNI_translations_y = -dL/voxel_size;
    AFNI_translations_z = -dS/voxel_size;
    AFNI_rotations_x = yaw;
    AFNI_rotations_y = pitch;
    AFNI_rotations_z = roll;

    % Load true parameters
    load([basepath_none '/b' bstring '_true_' amount '_rigid_parameters.mat']);

    % Calculate errors
    errors = zeros(st,6);
    errors(:,1) = AFNI_translations_x - x_translations;
    errors(:,2) = AFNI_translations_y - y_translations;
    errors(:,3) = AFNI_translations_z - z_translations;
    errors(:,4) = AFNI_rotations_x - x_rotations;
    errors(:,5) = AFNI_rotations_y - y_rotations;
    errors(:,6) = AFNI_rotations_z - z_rotations;

    errors_AFNI(s) = sqrt(sum(sum(errors.^2)));

end



%-------------------------------------------------------------------
% BROCCOLI 
%-------------------------------------------------------------------

errors_BROCCOLI = zeros(N,1);

for s = 1:N
    
    % Load estimated motion parameters
    fid = fopen([basepath_BROCCOLI '/b' bstring '_with_' amount '_rigid_motion_motionparameters.1D']);
    text = textscan(fid,'%f%f%f%f%f%f');
    fclose(fid);
    
    roll = text{1};
    pitch = text{2};
    yaw = text{3};

    dS = text{4}; % Superior
    dL = text{5}; % Left
    dP = text{6}; % Posterior

    BROCCOLI_translations_x = -dP/voxel_size;
    BROCCOLI_translations_y = -dL/voxel_size;
    BROCCOLI_translations_z = -dS/voxel_size;
    BROCCOLI_rotations_x = -roll;
    BROCCOLI_rotations_y = pitch;
    BROCCOLI_rotations_z = -yaw;
    
    % Load true parameters
    load([basepath_none '/b' bstring '_true_' amount '_rigid_parameters.mat']);
    
    % Calculate errors
    errors = zeros(st,6);
    errors(:,1) = BROCCOLI_translations_x - x_translations;
    errors(:,2) = BROCCOLI_translations_y - y_translations;
    errors(:,3) = BROCCOLI_translations_z - z_translations;
    errors(:,4) = BROCCOLI_rotations_x - x_rotations;
    errors(:,5) = BROCCOLI_rotations_y - y_rotations;
    errors(:,6) = BROCCOLI_rotations_z - z_rotations;
    
    errors_BROCCOLI(s) = sqrt(sum(sum(errors.^2)));
    
end

SPM_meanerror = mean(errors_SPM)
FSL_meanerror = mean(errors_FSL)
AFNI_meanerror = mean(errors_AFNI)
BROCCOLI_meanerror = mean(errors_BROCCOLI)

% Plot estimated parameters for SPM, FSL, AFNI och BROCCOLI
if show_parameters == 1
        
    %-----------------
    % True
    %-----------------
    
    % Load true parameters
    load([basepath_none '/b' bstring '_true_' amount '_rigid_parameters.mat']);
    
    figure(1)
    subplot(3,1,1)
    plot(SPM_translations_x,'c')
    hold on
    plot(FSL_translations_x,'r')
    hold on
    plot(AFNI_translations_x,'g')
    hold on
    plot(BROCCOLI_translations_x,'b')
    hold on
    plot(x_translations,'k')
    hold off
    xlabel('TR')
    ylabel('Voxels')
    title('X translations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')
    
    subplot(3,1,2)
    plot(SPM_translations_y,'c')
    hold on
    plot(FSL_translations_y,'r')
    hold on
    plot(AFNI_translations_y,'g')
    hold on
    plot(BROCCOLI_translations_y,'b')
    hold on
    plot(y_translations,'k')
    hold off
    xlabel('TR')
    ylabel('Voxels')
    title('Y translations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')
    
    subplot(3,1,3)
    plot(SPM_translations_z,'c')
    hold on
    plot(FSL_translations_z,'r')
    hold on
    plot(AFNI_translations_z,'g')
    hold on
    plot(BROCCOLI_translations_z,'b')
    hold on
    plot(z_translations,'k')
    hold off
    xlabel('TR')
    ylabel('Voxels')
    title('Z translations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')
    
    figure(2)
    subplot(3,1,1)
    plot(SPM_rotations_x,'c')
    hold on
    plot(FSL_rotations_x,'r')
    hold on
    plot(AFNI_rotations_x,'g')
    hold on
    plot(BROCCOLI_rotations_x,'b')
    hold on
    plot(x_rotations,'k')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('X rotations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')
    
    subplot(3,1,2)
    plot(SPM_rotations_y,'c')
    hold on
    plot(FSL_rotations_y,'r')
    hold on
    plot(AFNI_rotations_y,'g')
    hold on
    plot(BROCCOLI_rotations_y,'b')
    hold on
    plot(y_rotations,'k')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('Y rotations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')
    
    subplot(3,1,3)
    plot(SPM_rotations_z,'c')
    hold on
    plot(FSL_rotations_z,'r')
    hold on
    plot(AFNI_rotations_z,'g')
    hold on
    plot(BROCCOLI_rotations_z,'b')
    hold on
    plot(z_rotations,'k')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('Z rotations')
    legend('SPM','FSL','AFNI','BROCCOLI','Ground truth')        
    
end


% Plot errors for SPM, FSL, AFNI och BROCCOLI
if show_errors == 1
            
    figure(1)
    subplot(3,1,1)
    plot(SPM_translations_x_error,'c')
    hold on
    plot(FSL_translations_x_error,'r')
    hold on
    plot(AFNI_translations_x_error,'g')
    hold on
    plot(BROCCOLI_translations_x_error,'b')
    hold off
    xlabel('TR')
    ylabel('Voxels')
    title('X translations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
    
    subplot(3,1,2)
    plot(SPM_translations_y_error,'c')
    hold on
    plot(FSL_translations_y_error,'r')
    hold on
    plot(AFNI_translations_y_error,'g')
    hold on
    plot(BROCCOLI_translations_y_error,'b')
    hold on
    xlabel('TR')
    ylabel('Voxels')
    title('Y translations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
    
    subplot(3,1,3)
    plot(SPM_translations_z_error,'c')
    hold on
    plot(FSL_translations_z_error,'r')
    hold on
    plot(AFNI_translations_z_error,'g')
    hold on
    plot(BROCCOLI_translations_z_error,'b')
    hold off
    xlabel('TR')
    ylabel('Voxels')
    title('Z translations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
    
    figure(2)
    subplot(3,1,1)
    plot(SPM_rotations_x_error,'c')
    hold on
    plot(FSL_rotations_x_error,'r')
    hold on
    plot(AFNI_rotations_x_error,'g')
    hold on
    plot(BROCCOLI_rotations_x_error,'b')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('X rotations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
    
    subplot(3,1,2)
    plot(SPM_rotations_y_error,'c')
    hold on
    plot(FSL_rotations_y_error,'r')
    hold on
    plot(AFNI_rotations_y_error,'g')
    hold on
    plot(BROCCOLI_rotations_y_error,'b')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('Y rotations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
    
    subplot(3,1,3)
    plot(SPM_rotations_z_error,'c')
    hold on
    plot(FSL_rotations_z_error,'r')
    hold on
    plot(AFNI_rotations_z_error,'g')
    hold on
    plot(BROCCOLI_rotations_z_error,'b')
    hold off
    xlabel('TR')
    ylabel('Degrees')
    title('Z rotations')
    legend('SPM error','FSL error','AFNI error','BROCCOLI error')
       
end

