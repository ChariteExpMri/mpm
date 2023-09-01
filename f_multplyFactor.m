
%multiply data by factor
function f_multplyFactor(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_multplyFactor({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'});
end
%% =============  get PARAMETER ==================================
f_getconfig();
% g      =f_getmpm_config();
% [a2  c]=f_getparameters();
% pas=antcb('getsubjects');
% pa=pas{1};

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
cprintf('*[0 0 1]',[ 'Multiply by Factor'  '\n'] );
for i=1:length(mdirs)
    c.count=i;
    proc(mdirs{i},mpm,c);
end
cprintf('*[0 0 1]',[ 'DONE! '  '\n'] );


function proc(pa,mpm,c)

%% ===============================================

files={};
if ~isempty(find(strcmp(c.f(:,1),'MT')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'MT' '_\d+.nii' ]);
    if ~isempty(fis)
    MT=cellstr(fis);
    files=[files; MT];
    end
    
end
if ~isempty(find(strcmp(c.f(:,1),'PD')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'PD' '_\d+.nii' ]);
    PD=cellstr(fis);
    if ~isempty(fis)
        MT=cellstr(fis);
        files=[files; PD];
    end
end
if ~isempty(find(strcmp(c.f(:,1),'T1')))
    [fis] = spm_select('FPList',pa,  ['^x_' 'T1' '_\d+.nii' ]);
    T1=cellstr(fis);
    if ~isempty(fis)
        MT=cellstr(fis);
        files=[files; T1];
    end
end
% ==============================================
%%   multiply by factor
% ===============================================
factor=(mpm.multifactor);
if ischar(factor)    ; factor=str2num(factor); end
if isempty(factor)   ; factor=1;               end

cprintf('*[0 0 1]',[ 'multiply values by factor' num2str(factor) ' : '  '\n'] );

multiplicationTag=['/multi=' num2str(factor)];

for i=1:length(files)
    %% ===============================================
    
    H = spm_vol(files{i});
    desc=H.descrip;
    %desc='124'
    [tag ]=regexp(desc,'/multi=\d+','match'); tag=char(tag);
    descNew=[regexprep(desc,tag,'')  multiplicationTag ];
    if isempty(tag)
        prevFactor=1;
    else
        prevFactor=str2num(regexprep(tag,'/multi=','')) ;
    end
    
    %% ===============================================
    v=spm_read_vols(H);
    v = factor*(v)/prevFactor;
    H.descrip= descNew;
    spm_write_vol(H,v);
    %% ===============================================
    maxv=(max(v(:)));
    disp([ ' ..[multiply][' num2str(c.count) '-'  num2str(i)  ']: ' files{i}  '  -->max value: ' num2str(maxv)]);
    
end




% ==============================================
%%   
% ===============================================
return



% multiplicationTag='/multi=1';
% 
% cprintf('*[0 0 1]',[ 'multiply values by factor ' num2str(factor) ' : '  '\n'] );
% for i=1:length(files)
%     H = spm_vol(files{i});
%     if isempty(strfind(H.descrip,multiplicationTag))  ==1
%         V = factor*spm_read_vols(H);
%         H.descrip= [H.descrip multiplicationTag];
%         spm_write_vol(H,V);
%     else
%         disp(['   ...NIFTI already multiplied: '   files{i} ]  );
%     end
% end
