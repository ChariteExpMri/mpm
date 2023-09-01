
% #ko "f_runMRM_mode1.m"
% all images have to be in standard-space (SS)
% #b INPUT-FILES AND PARAMETERS 
% [RF]: using 'x_t2.nii' and 'x_mt2.nii' 
%    'x_t2.nii'  - is the t2-weighted image in SS
%    'x_mt2.nii' - is the bias-coRrected t2-weighted image in SS 
%                - generated using SPM's Unified Approach
%
% [B1-Bias coorection]: #r - B1-bias correction is not  used here !
%                       - here the input is 'noB1'
%   
% [raw_mpm]:  PD, MT and T1 data in SS are used
%     i.e multiple 3D-volumes for each modality is used:
%       'x_PD_00001.nii', 'x_PD_00002.nii','x_PD_00003.nii' ...etc  ...
%       'x_MT_00001.nii', 'x_MT_00002.nii','x_MT_00003.nii' ...etc  ...
%       'x_T1_00001.nii', 'x_T1_00002.nii','x_T1_00003.nii' ...etc  ...
% 
% 
% OUTPUT:
%  -currently the output is stored in the "results"-folder within each animal-folder
% 
% 
% 

function f_runMRM_mode1(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_runMRM_mode1({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'});
end
%% =============  get PARAMETER ==================================
f_getconfig();
% g      =f_getmpm_config();
% [a2  c]=f_getparameters();
% pas=antcb('getsubjects');
% pa=pas{1};

global mpm
a2=mpm.niftis.a2;
%% =========[animal dirs]======================================
if exist('mdirs')==1
    mdirs=cellstr(mdirs);
else
    global an
    if isempty(an)
        error(['error:animal-folders not specified' char(10) ...
            'OPTIONS: ' char(10) ...
            ' [1] specify folders via functions-input or' char(10)' ...
            ' [2] load study via ANTx-toolbox and select animals']);
    else
      mdirs=antcb('getsubjects');  
        
    end    
end
% disp(mdirs);
%% ===============================================



% addpath('F:\data7\MPM_mouse\spm12')
% addpath('F:\data7\MPM_mouse\hMRI-toolbox-0.2.4')
% cd('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01')
% ==============================================
%%   
% ===============================================
global an
c.use_mdirs_ANTx=0;
if ~isempty(which('ant.m'))  && ~isempty(an) && ~isempty(antcb('getsubjects'))
    c.use_mdirs_ANTx=1;
end
c.antpath=fileparts(which('antlink.m'));
c.wd     =pwd;
% ==============================================
%%   loop over subjects
% ===============================================
cprintf('*[0 0 1]',[ 'run MODEL[' mfilename '.m]'  '\n'] );
for i=1:length(mdirs)
    c.count=i;
    proc(mdirs{i},mpm,c);
end
cprintf('*[0 0 1]',[ 'DONE! '  '\n'] );
cd(c.wd);

function proc(pa,mpm,c)
% ==============================================
%%   
% ===============================================
% C:\Software\spm12\toolbox\hMRI-toolbox-0.2.4\config\local_abdomen\hmri_local_defaults.m

%  try; antlink(0); end
spm('defaults', 'FMRI');
cd(pa);
drawnow
%% =============[del subdirs]==================================
deleteDirs={'Results' 'B1mapCalc' 'RFsensCalc' 'MPMCalc'};
for i=1:length(deleteDirs)
   try; 
       rmdir(fullfile(pa,deleteDirs{i}),'s'); 
   end
end

% try;rmdir('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\'Results','s');end
% try;rmdir('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\'B1mapCalc','s');end
% try;rmdir('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\'RFsensCalc','s');end
% try;rmdir('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\'MPMCalc','s');end
% % try;rmdir('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\Run_02','s');end

%-----------------------------------------------------------------------
% Job saved on 16-Dec-2022 14:32:15 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
% mb{1}.spm.tools.hmri.hmri_config.hmri_setdef.standard = 'yes';
% mb{1}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {'C:\Software\spm12\toolbox\hMRI-toolbox-0.2.4\config\local_abdomen\hmri_local_defaults.m'};
% mb{1}.spm.tools.hmri.hmri_config.hmri_setdef.customised = {'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\paul_hmri_local_defaults.m'};

% ==============================================
%%   obtain files
% ===============================================

mousedefaults=mpm.hrmi_defaults;  %'F:\data7\MPM_mouse\MPM_mouse\mouse_template\hmri_local_defaults_mouse_paul.m';
% RF=stradd({'x_t2.nii' 'x_mt2.nii'},[pa filesep],1);
RF=cellfun(@(a){[[pa filesep a]]} ,{'x_t2.nii' 'x_mt2.nii'}');
n=mpm.niftis;

if ~isempty(find(strcmp(n.f(:,1),'MT')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'MT' '_\d+.nii' ]);
    MT=cellstr(fis);
end
if ~isempty(find(strcmp(n.f(:,1),'PD')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'PD' '_\d+.nii' ]);
    PD=cellstr(fis);
end
if ~isempty(find(strcmp(n.f(:,1),'T1')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'T1' '_\d+.nii' ]);
    T1=cellstr(fis);
end
% ==============================================
%%   fill matlabbatch-struct
% ===============================================



mb=[];
mb{1}.spm.tools.hmri.hmri_config.hmri_setdef.customised ={mousedefaults};

mb{2}.spm.tools.hmri.create_mpm.subj.output.indir = 'yes';
mb{2}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_once=RF;
% mb{2}.spm.tools.hmri.create_mpm.subj.sensitivity.RF_once = {
%                                                                      'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_t2.nii,1'
%                                                                      'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_mt2.nii,1'
%                                                                      };
mb{2}.spm.tools.hmri.create_mpm.subj.b1_type.no_B1_correction = 'noB1';
mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = MT;
% mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.MT = {
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00001.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00002.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00003.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00004.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00005.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_MT_00006.nii,1'
%                                                             };
mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD =PD;

% mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.PD = {
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00001.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00002.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00003.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00004.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00005.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00006.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00007.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_c_PD_00008.nii,1'
%                                                             };

mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 =T1;
% mb{2}.spm.tools.hmri.create_mpm.subj.raw_mpm.T1 = {
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00001.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00002.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00003.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00004.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00005.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00006.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00007.nii,1'
%                                                             'F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01\x_T1_00008.nii,1'
%                                                             };
mb{2}.spm.tools.hmri.create_mpm.subj.popup = false;


% ==============================================
%%   addpaths
% ===============================================
% if c.use_mdirs_ANTx==1
%     
% else
% %     
% end
%% ======[save matlabbatch]=========================================

pa_mpm=fileparts(mpm.mpm_configfile);
file2save=fullfile(pa_mpm,'job.mat');
% disp(['storted SPM-batch as  files'])
cprintf('*[0 .5 0]',[ 'saved SPM-batch: ' strrep(file2save,filesep, [filesep filesep])  '\n'] );
matlabbatch=mb;
save(file2save,'matlabbatch');
%% ===============================================


c.use_SPMextern=0;
if exist(mpm.SPM_path)==7
    c.use_SPMextern=1;
end

if c.use_SPMextern==1
    try; antlink(0); end
    addpath(mpm.SPM_path);
end
addpath(mpm.MPM_path);

% spm('defaults', 'FMRI');

cprintf('*[1 0 1]',[ 'current SPM-path: '   strrep(which('spm.m'),filesep,[filesep filesep])  '\n'] );

% ==============================================
%%   run
% ===============================================
% spm_jobman('interactive',mb)
% error: mb{2}.spm.tools.hmri.create_mpm.subj=[]
% mb{2}.spm.tools.hmri.create_mpm.subj=[];
if 1
    try
        spm_jobman('initcfg');
        spm_jobman('run',mb);
    catch ME
        posttask(mpm,c);
        rethrow(ME);
    end
end

posttask(mpm,c);

% ==============================================
%%   
% ===============================================
% global hmri_def
% hmri_def.TPM='F:\data7\MPM_mouse\MPM_mouse\mouse_template\mouseTPM.nii'

% ==============================================
%%   POST
% ===============================================
function posttask(mpm,c,use_SPMextern)

if c.use_mdirs_ANTx==1
    cd(c.antpath); antlink; 
end


if c.use_SPMextern==1 && c.use_mdirs_ANTx==1
       rmpath((mpm.SPM_path));
end
rmpath(mpm.MPM_path);



% cd(g.wd);

cd(c.wd);