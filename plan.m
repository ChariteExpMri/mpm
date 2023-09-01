
% ==============================================
%%   plan
% ===============================================
addpath('F:\data7\MPM_agBrandt\mpm_functions')
f_getconfig(fullfile('F:\data7\MPM_agBrandt\mpm\mpm_config.m'));


%copy MPM.parameters
f_copyMPMparameters();


%% insert original filenames
% MANUALLY!!!!

% obtain bruker parameters
f_obtainBrukerparameter();

%===================================================================================================
% ==============================================
%%   loop over subjects
% ===============================================

% copyANDrename files
f_renamefiles();

% register turborare to t1/pd/mt
f_registerTurborare();

% register to standardspace
 f_regist2SS();
 
 
% transform images to standard-space
f_transform2SS();
%% ===============================================
% ==============================================
%%   standalone
% ===============================================

tic

% split 4D-files
f_split4Dfiles();

%add HDR-description to final files in standardSpace
f_addHDRdescrition();

% multiplay by factor 2000
f_multplyFactor();

% run model
f_runMRM_mode1();

% normalize PD
f_PDnormalize();


toc






