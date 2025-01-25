% CONFIG-FILE FOR MPM
function mpm=mpm_config()
global mpm


%% ===============================================
%%          PARAMETER
%% ===============================================

%% ===============================================================================
%_PATH_OF_[hMRI-toolbox-0.2.4]  ..MANDATORY INPUT
mpm.MPM_path      ='F:\data7\MPM_mouse\hMRI-toolbox-0.2.4'   ;%MPM-toolbox path

%% ===============================================================================
%_PATH_OF_[SPM] ..leave empty to use SPM from ANTx or specify PATH  
%mpm.SPM_path      ='F:\data7\MPM_mouse\spm12'                ;%SPM-toolbox path
mpm.SPM_path     =''                                        ;%SPM-toolbox path



%% ======[LINKED PARAMETER-FILES]=================================================
mpm.hrmi_defaults    ='F:\data7\MPM_agBrandt\mpm\hmri_local_defaults_mouse.m'     ;%path of hMRI-configfile (m-file)
mpm.NIFTI_parameters ='F:\data7\MPM_agBrandt\mpm\mpm_NIFTIparameters.xlsx'        ;%path of NIFTI-parameter settings (excelfile)
%% ===============================================================================

mpm.t2w_preorient=[1.5708 0 1.5708];  % preorientation (rotations) of turborare (t2) to match orientation with PD/T1/MT-images
                                              % or leave empty if orientation matches

mpm.multifactor           = 2000;   % multiply images by this factor to widen dynamic range

% PD-normalization
mpm.PD_normalizeMask      ='F:\data7\MPM_agBrandt\mpm\mask_water.nii'  ;%reference-mask for normalization ('mask_ventricle.nii' or 'mask_water.nii' or use your own mask)
mpm.PD_normalizeFunction  =@mean                                       ;% function to aggregate the values within reference-mask
mpm.PD_normalizeOutputName='PD_normalized.nii'                         ;% resulting outputName


mpm.useParallelproc=0  ; %use parallelprocessing


