
% register to standardspace
function f_regist2SS(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_regist2SS({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
   
   mdirs={
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9'
       };
   f_regist2SS(mdirs)
   
end
%% =============  get PARAMETER ==================================
f_getconfig();
global mpm
a2=mpm.niftis.a2;
%% =========[animal dirs]======================================
mdirsExtern=0;
if exist('mdirs')==1
    mdirs=cellstr(mdirs);
    mdirsExtern=1;
    try
    antcb('selectdirs',mdirs); drawnow;
    end
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
% ==============================================
%%   
% ===============================================

if isfield(mpm, 'useParallelproc')
    isparfor=mpm.useParallelproc;
else
    isparfor=0;
end


% pas=antcb('getsubjects');
% isparfor=1;
if length(mdirs)==1
    isparfor=0;
end

%v.antxprojfile 
%% ===============================================

if mdirsExtern==0
    xwarp3('batch','task',[1:4],'autoreg',1,'parfor',isparfor ); %% REGISTRATION
else
    xwarp3('batch','task',[1:4 ],'autoreg',1,'parfor',isparfor, 'mdirs',mdirs(:) );
end

%% ===============================================
