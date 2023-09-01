function hmri_local_defaults_mouse
% PURPOSE
% To set user-defined (site- or protocol-specific) defaults parameters
% which are used by the hMRI toolbox. Customized processing parameters can
% be defined, overwriting defaults from hmri_defaults. Acquisition
% protocols can be specified here as a fallback solution when no metadata
% are available. Note that the use of metadata is strongly recommended. 
%
% RECOMMENDATIONS
% Parameters defined in this file are identical, initially, to the ones
% defined in hmri_defaults.m. It is recommended, when modifying this file,
% to remove all unchanged entries and save the file with a meaningful name.
% This will help you identifying the appropriate defaults to be used for
% each protocol, and will improve the readability of the file by pointing
% to the modified parameters only.
%
% WARNING
% Modification of the defaults parameters may impair the integrity of the
% toolbox, leading to unexpected behaviour. ONLY RECOMMENDED FOR ADVANCED
% USERS - i.e. who have a good knowledge of the underlying algorithms and
% implementation. The SAME SET OF DEFAULT PARAMETERS must be used to
% process uniformly all the data from a given study. 
%
% HOW DOES IT WORK?
% The modified defaults file can be selected using the "Configure toolbox"
% branch of the hMRI-Toolbox. For customization of B1 processing
% parameters, type "help hmri_b1_standard_defaults.m". 
%
% DOCUMENTATION
% A brief description of each parameter is provided together with
% guidelines and recommendations to modify these parameters. With few
% exceptions, parameters should ONLY be MODIFIED and customized BY ADVANCED
% USERS, having a good knowledge of the underlying algorithms and
% implementation. 
% Please refer to the documentation in the github WIKI for more details. 
%__________________________________________________________________________
% Written by E. Balteau, 2017.
% Cyclotron Research Centre, University of Liege, Belgium

% Global hmri_def variable used across the whole toolbox
global hmri_def

% Specify the research centre & scanner. Not mandatory.
hmri_def.centre = 'centre' ; % 'fil', 'lren', 'crc', 'sciz', 'cbs', ...
hmri_def.scanner = 'scanner name' ; % e.g. 'prisma', 'allegra', 'terra', 'achieva', ...

%==========================================================================
% Common processing parameters 
%==========================================================================

% cleanup temporary directories. If set to true, all temporary directories
% are deleted at the end of map creation, only the "Results" directory and
% "Supplementary" subdirectory are kept. Setting "cleanup" to "false" might
% be convenient if one desires to have a closer look at intermediate
% processing steps. Otherwise "cleanup = true" is recommended for saving
% disk space.
hmri_def.cleanup = false;
% settings for JSON metadata: by default, separate JSON files are used to
% store the metadata (information on data acquisition and processing,
% tracking of input and output files), as JSON-formatted, tab-indented
% text. The following settings are recommended. No modification currently
% foreseen as useful...
hmri_def.json = struct('extended',false,'separate',true,'anonym','none',...
    'overwrite',true, 'indent','\t'); 
% recommended TPM for segmentation and spatial processing. The hMRI toolbox
% provides a series of tissue probability maps. These TPMs could be
% replaced by other TPMs, to better match the population studied. 
% ADVANCED USER ONLY.
% hmri_def.TPM = '\\CHarite.de\Centren\AG\AG-Vaskulaere-Demenz\VCI\Graham\hmrimouse\mouseTPM.nii';

%hmri_def.TPM='F:\data7\MPM_mouse\MPM_mouse\mouse_template\__mouseTPM.nii'
 hmri_def.TPM='F:\data7\MPM_mouse\MPM_mouse\mouse_template\mouseTPM_mod.nii'

% default template for auto-reorientation. The template can be selected
% within the Auto-reorient module. The following is the default suggested
% for T1w images. Please refer to the Auto-reorient documentation for an
% appropriate choice of the template.
hmri_def.autoreorient_template = {fullfile(spm('dir'),'canonical','avg152T1.nii')};

%==========================================================================
% Default parameters for segmentation
% ADVANCED USERS ONLY!
% hmri_def.segment is effectively the job to be handed to spm_preproc_run
% By default, parameters are set to
% - create tissue class images (c*) in the native space of the source image
%   (tissue(*).native = [1 0]) for tissue classes 1-5
% - save both BiasField and BiasCorrected volume (channel.write = [1 1])
% - recommended values from SPM12 (October 2017)
%==========================================================================

% hmri_def.segment.channel.vols = cell array of file names, 
%                       must be defined before calling spm_preproc_run
hmri_def.segment.channel.biasreg = 0.001;
hmri_def.segment.channel.biasfwhm = 60;
% hmri_def.segment.channel.write = [0 0]; % save nothing
% hmri_def.segment.channel.write = [1 0]; % save BiasField
% hmri_def.segment.channel.write = [0 1]; % save BiasCorrected volume
hmri_def.segment.channel.write = [1 1]; % save BiasField and BiasCorrected volume

hmri_def.segment.tissue(1).tpm = {[hmri_def.TPM ',1']};
hmri_def.segment.tissue(1).ngaus = 1;
hmri_def.segment.tissue(1).native = [1 0];
hmri_def.segment.tissue(1).warped = [0 0];
hmri_def.segment.tissue(2).tpm = {[hmri_def.TPM ',2']};
hmri_def.segment.tissue(2).ngaus = 1;
hmri_def.segment.tissue(2).native = [1 0];
hmri_def.segment.tissue(2).warped = [0 0];
hmri_def.segment.tissue(3).tpm = {[hmri_def.TPM ',3']};
hmri_def.segment.tissue(3).ngaus = 2;
hmri_def.segment.tissue(3).native = [1 0];
hmri_def.segment.tissue(3).warped = [0 0];
hmri_def.segment.tissue(6) = [];
hmri_def.segment.tissue(5) = [];
hmri_def.segment.tissue(4) = [];
hmri_def.segment.warp.mrf = 1;
hmri_def.segment.warp.cleanup = 1;
hmri_def.segment.warp.reg = [0 0.001 0.5 0.05 0.2];
hmri_def.segment.warp.affreg = 'mni';
hmri_def.segment.warp.fwhm = 0;
hmri_def.segment.warp.samp = 3;
hmri_def.segment.warp.write = [0 0];

% hmri_def.qMRI_maps_thresh.R1       = 5000; % 1000*[s-1]

%% ========= from Stefan Hetzter ======================================
hmri_def.qMRI_maps_thresh.R1       = 2000*10;    %1000*[s-l] %SH: added '*10'
hmri_def.qMRI_maps_thresh.A        = 10^5   ;  % [a.u.] based on input images with ir
hmri_def.qMRI_maps_thresh.R2s      = 10     ;  % 1000*[s-l]
hmri_def.qMRI_maps_thresh.MTR      = 50     ;
hmri_def.qMRI_maps_thresh.MTR_synt = 50     ;
hmri_def.qMRI_maps_thresh.MT       = 5*10   ;   % [p.u.] %SH: added '*10'
%% ===============================================


%===============================================================
% R1/PD/R2s/MT map creation parameters
%==========================================================================

%--------------------------------------------------------------------------
% Coregistration of all input images to the average (or TE=0 fit) PDw image
%--------------------------------------------------------------------------
% The coregistration step can be disabled using the following flag (not
% recommended). ADVANCED USER ONLY. 
hmri_def.coreg2PDw = 0; 
% 
% end
