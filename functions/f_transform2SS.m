

% transform images to standard-space
function f_transform2SS(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_transform2SS({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
   
   mdirs={
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9'
       };
   f_transform2SS(mdirs)
   
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
% ==============================================
%%   
% ===============================================

%% =============  get PARAMETER ==================================
% 
% g      =f_getmrm_config();
% [a2  c]=f_getparameters();

%% ===============================================
t=mpm.niftis.f;
% t=c.f;
t(strcmp(t(:,1),'t2w'),:)=[]; %without t2w
files=stradd(t(:,1),'.nii',2); 
files{end+1,1}='mt2.nii';


interpvec=[];
for i=1:length(files)
    switch files{i}
        case   { 'T1.nii'    'MT.nii'    'PD.nii'}
            interp=1;
         case   { 'mt2.nii'}
              interp=3;
        otherwise
            interp=1; %has to be done
    end
    %fis=doelastix(1, [] ,files{i},interp,'local');
    interpvec(i,1)=interp;
end

if isfield(mpm, 'useParallelproc')
    isparfor=mpm.useParallelproc;
else
    isparfor=0;
end

%% ===============================================
cprintf('*[0 0 1]',[ 'transform files to standard-space: '  '\n'] );
interpValues=unique(interpvec);
for i=1:length(interpValues)
    thisInterp    =interpValues(i);
    files2=files(find(interpvec==thisInterp));
    if isparfor==0
        fis=doelastix(1, [] ,files2,thisInterp,'local');
    else
        fis=doelastix(1, [] ,files2,thisInterp,'local',struct('isparallel',isparfor) );
    end
end




%% ===============================================



