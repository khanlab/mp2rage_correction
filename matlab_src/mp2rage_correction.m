function [] = mp2rage_correction(inv1,inv2,Sa2RAGE_filename,Sa2RAGE_B1_filename,MP2RAGE_filename,B1_para_filename,MP2RAGE_para_filename,MP2RAGE_corrected_output_filename,T1_corrected_output_filename,B1_corrected_output_filename,uni_den)

% Scripts to remove residual B1 bias from T1 maps calculated with the
% MP2RAGE sequence
% Correction of T1 estimations as sugested on:
% Marques, J.P., Gruetter, R., 2013. New Developments and Applications of the MP2RAGE Sequence - Focusing the Contrast and High Spatial Resolution R1 Mapping. PLoS ONE 8. doi:10.1371/journal.pone.0069294
%
% in this script it is assumed that the Sa2RAGE UNI image has been coregistered to the
% space of the MP2RAGE image and that they now have the B1 has in the
% process been interpolated to the same resolution.
% 
% test:
% mp2rage_correction('sa2rage_UNI_Images.nii.gz','mp2rage_sag_700iso_p3_944_UNI_Images.nii.gz','sa2rage_parameters.csv','mp2rage_parameters.csv','MP2rage_corrected.nii','T1_corrected.nii') 
%
 
if nargin < 6
    disp('usage: <SA2RAGE_UNI_filename(.nii.gz)> <SA2RAGE B1 filename (.nii)> <MP2RAGE_UNI_filename(.nii/.nii.gz)> <B1_para_filename(.csv)> <MP2RAGE_para_filename(.csv)> <MP2RAGE_corrected_output_filename(.nii)> <T1_UNI_corrected_output_filename(.nii)> ');
    return
end
    

addpath(genpath('.'))

%disp(B1_para_filename)
%disp(class(B1_para_filename))

sa2rage_p = readtable(B1_para_filename);
Sa2RAGE.TR = str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'TR'))} );
Sa2RAGE.TRFLASH = str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'TRFLASH'))} );
Sa2RAGE.TIs=str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'TIs'))} );
Sa2RAGE.NZslices=str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'NZslices'))} );
Sa2RAGE.FlipDegrees=str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'FlipDegrees'))} );
Sa2RAGE.averageT1=str2num( sa2rage_p.Var2{find(strcmp(sa2rage_p.Var1,'averageT1'))} );
Sa2RAGE.filename=Sa2RAGE_filename;

%load B1 image
if ~isempty(Sa2RAGE_B1_filename)
    B1=load_untouch_nii(Sa2RAGE_B1_filename);
else
    B1=[];
end
Sa2RAGEimg=load_untouch_nii(Sa2RAGE.filename);

mp2rage_p = readtable(MP2RAGE_para_filename);
MP2RAGE.B0 = str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'B0'))} );
MP2RAGE.TR = str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'TR'))} );
MP2RAGE.TRFLASH = str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'TRFLASH'))} );
MP2RAGE.TIs=str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'TIs'))} );
MP2RAGE.NZslices=str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'NZslices'))} );
MP2RAGE.FlipDegrees=str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'FlipDegrees'))} );
MP2RAGE.InvEFF=str2num( mp2rage_p.Var2{find(strcmp(mp2rage_p.Var1,'InvEFF'))} );

MP2RAGE.filename=MP2RAGE_filename;
% additionally the inversion efficiency of the adiabatic inversion can be
% set as a last optional variable. Ideally it should be 1. 
% In the first implementation of the MP2RAGE the inversino efficiency was 
% measured to be ~0.96



%load MP2RAGE image
MP2RAGEimg=load_untouch_nii(MP2RAGE.filename);


%   YingLi Lu commented this! read these parameters from config file
%     %% Lau DBS Sa2RAGE protocol info and loading the Sa2RAGE data for B1 estimation
% 
%     Sa2RAGE.TR=2.4;
%     Sa2RAGE.TRFLASH=2.2e-3;
%     Sa2RAGE.TIs=[45e-3 1800e-3];
%     Sa2RAGE.NZslices=128.*[0.25 0.5]./2 ; %+[7.5 7.5];% Base Resolution * [PartialFourierInPE-0.5  0.5]/iPATpe+[RefLines/2 RefLines/2]*(1-1/iPATpe )
%     Sa2RAGE.FlipDegrees=[4 11];
%     Sa2RAGE.averageT1=1.5;
%     Sa2RAGE.B1filename=B1_filename;
% 
%     B1=load_untouch_nii(Sa2RAGE.B1filename);
%     
%     
%     
%     %% Lau DBS protocol:
%     
%     
%     MP2RAGE.B0=7;           % in Tesla
%     MP2RAGE.TR=6;           % MP2RAGE TR in seconds 
%     MP2RAGE.TRFLASH=7.9e-3; % TR of the GRE readout
%     MP2RAGE.TIs=[800e-3 2700e-3];% inversion times - time between middle of refocusing pulse and excitatoin of the k-space center encoding
%     MP2RAGE.NZslices=[56 112];% Slices Per Slab * [PartialFourierInSlice-0.5  0.5]  % 24 * [6/8-0.5   0.5] = [56 112]
%     MP2RAGE.FlipDegrees=[4 5];% Flip angle of the two readouts in degrees
%     MP2RAGE.filename=MP2RAGE_filename;

    
    
%     % check the properties of this MP2RAGE protocol... this happens to be a
%     % very B1 insensitive protocol
% 
%     
%     %plotMP2RAGEproperties(MP2RAGE)
% 
%     % load the MP2RAGE data
%     MP2RAGEimg=load_untouch_nii(MP2RAGE.filename);
%     
    

%% performing the correction    

    [ B1corr T1corrected MP2RAGEcorr] = T1B1correctpackage( Sa2RAGEimg,B1,Sa2RAGE,MP2RAGEimg,[],MP2RAGE,[],MP2RAGE.InvEFF);
    
  

    %%  saving the data 
    save_untouch_nii(MP2RAGEcorr,MP2RAGE_corrected_output_filename) 
    save_untouch_nii(T1corrected,T1_corrected_output_filename)
    save_untouch_nii(B1corr,B1_corrected_output_filename)
    
    %% also need to generate and save the UNI-DEN image 
    multiplyingFactor=6;

    [MP2RAGEimgRobustPhaseSensitive]=RobustCombination(MP2RAGE_corrected_output_filename,inv1,inv2,uni_den,multiplyingFactor);

    
    
