
%copy resulting NIFTI-files to upper animal-folder
function f_copyNIFTI2animalDir(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_copyNIFTI2animalDir({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
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
c=struct();
% ==============================================
%%   loop over subjects
% ===============================================
cprintf('*[0 0 1]',[ 'copy NIFTIs to upper animalDIR'  '\n'] );
for i=1:length(mdirs)
    c.count=i;
    proc(mdirs{i},mpm,c);
end
cprintf('*[0 0 1]',[ 'DONE! '  '\n'] );


function proc(pa,mpm,c)

% ==============================================
%%   get Imput-NIFTI
% ===============================================

pares=fullfile(pa,'Results');
[fis] = spm_select('FPList',pares,  ['^x_PD' '.*' '.nii$' ]);
if isempty(fis); return; end
fis=cellstr(fis);

% ==============================================
%%   
% ===============================================
cprintf('[0 0 1]',[ 'copy files: ['  strrep(pa,filesep,[filesep filesep])  ']'  '\n'] );
for i=1:length(fis)
   f1=fullfile(fis{i}) ;
   [~,niiname,ext]=fileparts(f1);
   f2=fullfile(pa,[ niiname,ext]);
   copyfile(f1,f2,'f'); 
  try; showinfo2(['copied to AnimalDir:' ],f2); end
end






