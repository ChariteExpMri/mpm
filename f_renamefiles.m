

%rename files
function f_renamefiles(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_renamefiles({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
   
   mdirs={
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9'
       };
   f_renamefiles(mdirs)
   
end
%% =============  get PARAMETER ==================================
f_getconfig();
global mpm
a2=mpm.niftis.a2;
%% =========[animal dirs]======================================
if exist('mdirs')==1
    mdirs=cellstr(mdirs);
    antcb('selectdirs',mdirs); drawnow;
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

%% ===============================================
files=mpm.niftis.f;
% files=c.f;


for i=1:size(files,1)
   xrename(0,  files{i,2}  , [files{i,1} '.nii'],  ':');  
end