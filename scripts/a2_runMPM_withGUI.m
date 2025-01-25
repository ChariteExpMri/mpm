
% ==============================================
%%  MPM, run all tasks for all animals
% ===============================================


% ==============================================
%%  option-A : select animals via antx
% ===============================================
if 1
    clear ; cf;
    studyDir='F:\data8_MPM\2024_Cuprizone_Exvivo_MPM_DTI'     %# please set antx-study-path
    ant;
    antcb('load', fullfile(studyDir,'proj.m'));
    antcb('selectdirs','all') ;   % or select first two animals antcb('selectdirs',[1 2]) ;
    
    v=struct();
    v.mpm_configfile   =fullfile(studyDir,'mpm', 'mpm_config.m' ) ; % mpm-configfile
    v.pstep            = 'all';%'all'%[1 3];[1:5]    ; % indices of preprocessing steps  , use 'all' or use indices such as:  [1:5]; see mpm('steps');
    v.hstep            = 'all';%['all'];%[1:6]     ; % indices of hmri-processing steps, use 'all' or use indices such as:  [1:5]; see mpm('steps');
    mpm('gui',v)  ; % run proccessing steps without GUI
end

% ==============================================
%%  option-B: : select animals via mdirs-array
% ===============================================
if 0
    clear ; cf;
    studyDir='F:\data8_MPM\2024_Cuprizone_Exvivo_MPM_DTI'
    ant;
    antcb('load', fullfile(studyDir,'proj.m'));
    
    mdirs=antcb('getallsubjects');
    v=struct();
    v.mpm_configfile   =fullfile(studyDir,'mpm', 'mpm_config.m' ) ; % mpm-configfile
    v.pstep            = 'all';%'all'%[1 3];[1:5]    ; % indices of preprocessing steps  , use 'all' or use indices such as:  [1:5]; see mpm('steps');
    v.hstep            = 'all';%['all'];%[1:6]     ; % indices of hmri-processing steps, use 'all' or use indices such as:  [1:5]; see mpm('steps');
    v.mdirs            =  mdirs;% or mdirs(1:2); %'all' ; %  animals from 'dat'-folder are used
    mpm('gui',v)  ; % run proccessing steps without GUI
end