
% read config_file: mpm_config.m + NIFTI-parameters(excelfile)  --> produce global "mpm"
% [initialize]:
%  f_getconfig(fullfile('F:\data7\MPM_agBrandt\mpm\mpm_config.m'))
% [update] ...after initialization
%  f_getconfig()
%

function g=f_getconfig(mpm_configfile)

if 0
    f_getconfig(fullfile('F:\data7\MPM_agBrandt\mpm\mpm_config.m'));
    f_getconfig();
end

% ==============================================
%%   [1] part-1 read config
% ===============================================

isOK=0;
if exist('mpm_configfile')==1
    getconfigparameters(mpm_configfile);
    isOK=1;
else
    global mpm
    if ~isempty(mpm)
        getconfigparameters(mpm.mpm_configfile);
        isOK=1;
        
    else
        error('mpm-struct is empty...see help of f_getconfig') ;
    end
end

% ==============================================
%%   [2] read NIFTI-parameters
% ===============================================
if isOK==1
    global mpm
    f1=mpm.NIFTI_parameters;
    [~,~,a]=xlsread(f1);
    ha=a(1,:);
    a=a(2:end,:);
    
    
    a2=cellfun(@(a){[num2str(a)]} ,a);
    
    c.info1='*** NIFTIparameters fromm excelfile';
    c.info2={
        '[ha]:header'
        '[a] :xlstable (original) '
        '[a2]:xlstable(all strings)'
        '[f] :table with defined NIFTI-files'
        };
    c.xlsfile=f1;
    c.ha=ha;
    c.a =a;
    c.a2=a2;
    
    c.f=c.a2(strcmp(c.a2(:,2),'NaN')==0,:);
    mpm.niftis=c;
else
    disp('could not load NIFTI-parameters!!!');
    
end





%% ===============================================

return

pw=pwd;
global an
patemp=fullfile(fileparts(an.datpath), 'mpm');
cd(patemp);
g=mrm_config();
cd(pw);

% fullfile(fileparts(an.datpath),'mrm_config.m')


function getconfigparameters(mpm_configfile)
pw=pwd;
[pa file ext]=fileparts(mpm_configfile);
cd(pa);
evalc(file);

disp([' MPM-configfile: ["' [file ext] '"] loaded as "mpm" (global variable)' ]);
cd(pw)

global mpm
mpm.mpm_configfile=mpm_configfile;
% 'updated'