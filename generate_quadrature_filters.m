
close all
clear all
clc

addpath('/home/andek/Research_projects/kerngen/')
addpath('/home/andek/Research_projects/kerngen_old/')
addpath('kerngen/')

directions = 200;

filter_size = 15;
spatial_rexp = 2;
frequency_rexp = -1;
cosexp = 1;
SNRest = 40;

% Center frequency and bandwidth (in octaves)
u0 = pi/5;
B = 1.7;

% Sizes
spatial_size = [filter_size filter_size filter_size];
frequency_size = 2*spatial_size+1;

% Frequency weights
Fw = F_weightgensnr(frequency_size,frequency_rexp,cosexp,SNRest);

% Spatial weights
fw0 = goodsw(spatial_size,spatial_rexp);
%wamesh(fw0)
fw_amp = 30;
fw = fw_amp.*fw0;

% Spatial ideal filter
fi = wa(spatial_size,0);
fi = putorigo(fi,1);

% Spatial mask
fm = wa(spatial_size,0);
fm = putdata(fi,ones(spatial_size));

% Load directions
load data/X_200_1shell_fixed_4.00_2.00_4.00_0.75_J0_S1.mat
dir = rivec1(:,1:2:end);

% Frequency ideal filters
for k = 1:directions
    Fi{k} = quadrature(frequency_size,u0,B,dir(:,k));
end

%figure(1); wamesh(Fi{1})

% Optimize the quadrature filters
disp('Optimizing filters')
for k = 1:directions
    k
    [f{k},F{k}] = krnopt(Fi{k},Fw,fm,fi,fw);
end

%figure; wamesh(real(f{3}))
%figure; wamesh(F{2})
%pause

filterr(F{1},Fi{1},Fw,fi,fw,1);

save('quadrature_filters.mat','f')

%    f1 = getdata(f{1});

