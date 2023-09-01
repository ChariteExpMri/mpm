
% split 4Dfiles in standard-soace
function f_split4Dfiles(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_split4Dfiles({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'});
end
%% =============  get PARAMETER ==================================
f_getconfig();
global mpm
c.f=mpm.niftis.f;
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

% ==============================================
%%   loop over subjects
% ===============================================
cprintf('*[0 0 1]',[ 'Converting 4D to 3D-files '  '\n'] );
for i=1:length(mdirs)
    c.count=i;
    proc(mdirs{i},mpm,c);
end
cprintf('*[0 0 1]',[ 'DONE! '  '\n'] );


% ==============================================
%%   
% ===============================================

function proc(pa,mpm,c)

[~,animal]=fileparts(pa);
files0=c.f(:,1);
files0(strcmp(files0,'t2w'))=[];
files=cellfun(@(a){[  pa filesep 'x_' num2str(a) '.nii']} ,files0);

for i=1:length(files)
   disp([ ' ..[split 4D][' num2str(c.count) '-'  num2str(i)  ']: ' files{i} ]);
    if exist(files{i})==2
        mb={};
        mb{1}.spm.util.split.vol = {files{i}};
        mb{1}.spm.util.split.outdir = {pa};
        [msg o1 o2]=evalc('spm_jobman(''run'',mb)');
       
    else
       cprintf('[1 0 1]',[ ' ! ' strrep(files{i},filesep, [filesep filesep]) ' does not exist! '  '\n'] ); 
    end
end

% [o1 o2]=spm_jobman('run',mb)


% o1{1}.splitfiles

% clear mb
% mb{1}.spm.util.split.vol = {'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4\x_T1.nii'};
% mb{1}.spm.util.split.outdir = {'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'};













return







%% =============  get PARAMETER ==================================

g      =f_getmrm_config();
[a2  c]=f_getparameters();
pas=antcb('getsubjects');
pa=pas{1};
%% ===============================================


files0=c.f(:,1);
files0(strcmp(files0,'t2w'))=[];
files=stradd(files0,'.nii',2);
files=stradd(files,'x_',1);

for i=1:length(files)
    f1= fullfile(pa,files{i});
    hb=spm_vol(f1);
    if length(hb)>1
        cprintf('*[0 0 1]',[ ['splitting 4Dvol: '  files{i}] '\n'] );
        xrename(0,files{i},files{i},':s');
    end
end

% %% ======[add HDR-description ]=========================================
% 
% for i=1%
% px=antcb('getsubjects') 
%  [fis] = spm_select('List',px{1},  ['^x_' files0{i} '_\d\d\d.nii' ]);
%  fis=cellstr(fis)
%  
%  
%  
% 
% 
% 
% end



