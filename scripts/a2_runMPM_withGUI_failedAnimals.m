

% ==============================================
%%   a2_registerFailedAnimals
% ===============================================
tic
mdirs={
'20240828LA_CupExvivo_F01_dMRI_MPM_MWF'
'20240829LA_CupExvivo_F02_dMRI_MPM_MWF'
'20240829LA_CupExvivo_F03_dMRI_MPM_MWF'
'20240829LA_CupExvivo_M05_dMRI_MPM_MWF'
}

pastudy='H:\Daten-2\Imaging\AG_Paul_Brandt\analysis_2025\2024_Cuprizone_Exvivo_MPM_DTI'
ant

antcb('load',fullfile(pastudy,'proj_failedregistration.m'));
antcb('selectdirs',mdirs)

% ==============================================
%%   witer mit MPM
% ===============================================

% 
% global an
% an.wa.usePriorskullstrip=7  %[1,6,3]not working: [2,4]no skullstripping/does nothing
% xwarp3('batch','task',[1 2]);
% 
% toc