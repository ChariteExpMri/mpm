
%setup: copy necessary stuff
% 
% no-GUi option to copy necessary files
%f_setup('ini')

function f_setup(arg)




%% ===============================================

pas=fullfile(fileparts(which('mpm.m')),'resources');
p.path_resources=pas;
p.files2copy={...
    'mpm_NIFTIparameters.xlsx'    'copy NIFTI-parameter file (Excelfile)'   1  'copy_NIFTIparam'  ...
    ['mandatory file: "mpm_NIFTIparameters.xlsx" ' char(10) ...
    'File is used to specify NIFTI-files and Bruker-parameters(FA/TR/TE)']
    ...
    'mpm_config.m'                'copy mpm_config file (m-file)'           1  'copy_mpm_config'  ...
    ['mandatory file: "mpm_config.m" ' char(10) ...
    'File is used to specify paths and global parameters' char(10) ...
    '"mpm_config.m"-variables are stored in the global variable "mpm"']
    ...
    'hmri_local_defaults_mouse.m' 'copy hmri_config file (m-file)'          1  'copy_hmri_config' ...
    ['mandatory file: "hmri_local_defaults_mouse.m" ' char(10) ...
    'Parameters defined for hMRI-toolbox' char(10) ...
    '..in most cases there is no need to change this files ']
    ...
    };


if exist('arg')==1
    if ischar(arg)==1 && strcmp(arg,'ini')
        
        p.isgui=0;
        
        proc_ok([],[],p)
        return
    end 
end


makefig(p);

% ==============================================
%%   
% ===============================================


function makefig(p)

delete(findobj(0,'tag','mpm_setup'));
figure
set(gcf,'menubar','none','tag','mpm_setup','name',['mpm_setup [' mfilename '.m]' ],'NumberTitle','off','color','w','units','norm');
set(gcf,'position',[ 0.4049    0.4044    0.2924    0.3256]);

%% ==========[TXT: main]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[0 0 1]);
set(hb,'position',[0.049742 0.91298 0.9 0.05],'fontweight','bold');
set(hb,'HorizontalAlignment','left');
set(hb,'string','Setup: copy files to selected path','foregroundcolor',[0 0 1],'backgroundcolor','w');

%% ==========[copy files]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','copy files');
set(hb,'position',[0.042617 0.20659 0.1425 0.0683]);
set(hb,'callback',{@proc_ok,1});
set(hb,'backgroundcolor',[ 0.8941    0.9412    0.9020]);

set(hb,'tooltipstring',['copy selected files to destination path ' ]);

%% ==========[open files]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','open files');
set(hb,'position',[0.042617 0.135 0.1425 0.0683]);
set(hb,'callback',{@open_files});

set(hb,'tooltipstring',['open selected files from destination path ' char(10)...
    'First, copy files to destination path...' char(10)...
    'Than select "open files" to open and modify files.  ']);

%% ==========[open folder]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','open folder');
set(hb,'position',[0.18749 0.135 0.1425 0.0683]);
set(hb,'callback',{@open_destpath});

set(hb,'tooltipstring',['open destination path in explorer' ]);


%% ==========[close]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','Close');
set(hb,'position',[0.80974 0.02573 0.1425 0.0683]);
set(hb,'callback',{@proc_ok,0});

set(gcf,'userdata',p);

set(hb,'tooltipstring',['close figure ' ]);

%% ===============================================
pos=[0.059242 0.64 0.8 0.047];
for i=1:size(p.files2copy,1)
    hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
    set(hb,'string',p.files2copy{i,2});
    set(hb,'position',[ pos(1) pos(2)-(i-1).*0.06 pos(3:4)]);
    set(hb,'tag',p.files2copy{i,4}  );
    set(hb,'value',p.files2copy{i,3});
    
    set(hb,'tooltipstring',p.files2copy{i,5});
end

%% ===============================================


% if 0
%     
%     %==========[copy: mpm_NIFTIparameters]=====================================
%     hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
%     set(hb,'string','copy NIFTI-parameter file (Excelfile)');
%     set(hb,'position',[0.059242 0.64 0.8 0.047]);
%     set(hb,'tag','copy_niftiparamfile');
%     set(hb,'value',1);
%     %==========[copy: mpm_config]=====================================
%     hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
%     set(hb,'string','copy mpm_config file (m-file)');
%     set(hb,'position',[0.059242 0.58 0.8 0.047]);
%     set(hb,'tag','copy_mpmconfigfile');
%     set(hb,'value',1);
%     %==========[copy: hmri_local_defaults_mouse]=====================================
%     hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
%     set(hb,'string','copy hmri_config file (m-file)');
%     set(hb,'position',[0.059242 0.52 0.8 0.047]);
%     set(hb,'tag','copy_hmriconfigfile');
%     set(hb,'value',1);
% end

%% ==========[presettings]=====================================
pathis=pwd;
pa_resource=fullfile(fileparts(which('mpm.m')),'resources');
cd(pa_resource);
tb=mpm_miscsettings;
cd(pathis);


ht=uicontrol('style','text','units','norm','backgroundcolor',[1 1 1]);
set(ht,'string','path-preselection');
set(ht,'position',[[0.67199 0.76283 0.3 0.06825]],'fontweight','bold','horizontalalignment','left');
% ----
hb=uicontrol('style','popupmenu','units','norm','foregroundcolor',[0 0 1]);
% set(hb,'position',[0.13524 0.37039 0.9 0.05],'fontweight','normal');
set(hb,'HorizontalAlignment','left');
set(hb,'string',tb(:,1),'tag','preselection')
set(hb,'position',[0.67199 0.58197 0.3 0.2],'fontweight','normal');
set(hb,'tooltipstring','pre-selection of paths in configfile (or edit file)');
%% ===============================================





%% ==========[TXT: destpath]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[0 0 1]);
set(hb,'position',[0.13524 0.37039 0.9 0.05],'fontweight','normal');
set(hb,'HorizontalAlignment','left');
set(hb,'string','Destination path','foregroundcolor',[0 0 1],'backgroundcolor','w');

%% ========edit destinationPath =======================================
hb=uicontrol('style','edit','backgroundcolor','w','units','norm');
set(hb,'string','--not defined--');
set(hb,'position',[0.13287 0.32262 0.86 0.055]);
set(hb,'tag','ed_destinpath');
set(hb,'backgroundcolor',[repmat(0.9,[1 3])]);
set(hb,'HorizontalAlignment','left');

set(hb,'tooltipstring',['destination path ' char(10)...
    'This folder will contain the configuration-files. ']);

global an
global mpm
if ~isempty(mpm)
    try
        destpath=fileparts(mpm.mpm_configfile);
        set(hb,'string',destpath);
    end
elseif ~isempty(an)
    try
        destpath=fullfile(fileparts(an.datpath),'mpm');
        set(hb,'string',destpath);
    end
end

%% ==========[PB:destinationpath]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','select');
set(hb,'position',[0.038005 0.32253 0.09 0.055]);
set(hb,'callback',{@getdestpath});

set(hb,'tooltipstring',['click here to select the destination path ' char(10)...
    'This folder will contain the configuration-files. ']);

% %% ==========[check: open files for editong after copying]=====================================
% 
% hb=uicontrol('style','check','backgroundcolor','w','units','norm');
%     set(hb,'string','open files');
%     set(hb,'position',[ pos(1) pos(2)-(i-1).*0.06 pos(3:4)]);
% %     set(hb,'tag',p.files2copy{i,4}  );
% %     set(hb,'value',p.files2copy{i,3});



function open_destpath(e,e2)
hb=findobj(gcf,'tag','ed_destinpath');
destpath=get(hb,'string')

if exist(destpath)~=7
    disp(['path does not exist: ' destpath ]);
    return
end

if ispc
    eval(['!explorer ' destpath ]);
elseif ismac
    system(['open '  destpath ' &']);
else
    %             system(['nautilus "'  paths{i} '" &' ]);
    system(['xdg-open "'  destpath '" &' ]);
end


%% ===============================================

% files2copy={...
%     'mpm_NIFTIparameters.xlsx'
%     'mpm_config.m'
%     'hmri_local_defaults_mouse.m'
%     };
function getdestpath(e,e2)
%% ===============================================
[r1 ]=uigetdir(pwd,'select destination path ');
if isnumeric(r1);
%     set(hb,'string','--not defined--');
    return; 
end
%% ===============================================
[pa sub]=fileparts(r1);
sub2='mpm';
if strcmp(sub,sub2); sub2=''; end
destpath=fullfile(pa,sub);


k=dir(destpath); fis={k(:).name}'; % check if 'destpath' is not studydir
if isempty(find(~cellfun(@isempty, regexpi(fis,'^dat$|^proj.m$|^raw$|^templates$'))))
    
else
    destpath=fullfile(pa,sub,sub2);
end
    
hb=findobj(gcf,'tag','ed_destinpath');
set(hb,'string',destpath);


%% ===============================================
function open_files(e,e2)
u=get(gcf,'userdata');
f=u.files2copy;
val=[];
for i=1:size(f,1)
    hb=findobj(gcf,'tag',f{i,4});
    val(i,1)=hb.Value;
end
f=f(val==1,:);
% ----------path
hb=findobj(gcf,'tag','ed_destinpath');
destpath=get(hb,'string');
[pa sub]=fileparts(destpath);
if exist(pa)~=7
    disp('no valid destination path, please select a proper destination  path');
    return
end
%% ===============================================

if ispc; comd='start ';
    elseif ismac; cmd='open ';
    elseif isunix; cmd='xdg-open ';
end
    
for i=1:size(f,1)
    f2=fullfile(destpath        ,  f{i,1});
    [~,~,ext]=fileparts(f2);
    if strcmp(ext,'.xlsx') || strcmp(ext,'.xls')
        system([comd f2]);
    elseif strcmp(ext,'.m') 
        edit(f2);
    end
    disp([' ...opening : '  f2]);
end
%% ===============================================





function proc_ok(e,e2,arg)
% arg
isgui=1;
if isstruct(arg)
    s=arg;
    isgui=s.isgui;
elseif isnumeric(arg)
    if arg==0
        close(gcf);
        return
    end
end
%% ===============================================

if isgui==1;
    u=get(gcf,'userdata');
    f=u.files2copy;
    val=[];
    for i=1:size(f,1)
        hb=findobj(gcf,'tag',f{i,4});
        val(i,1)=hb.Value;
    end
    f=f(val==1,:);
    % ----------path
    hb=findobj(gcf,'tag','ed_destinpath');
    destpath=get(hb,'string');
    [pa sub]=fileparts(destpath);
    if exist(pa)~=7
        disp('no valid destination path, please select a proper destination  path');
        return
    end
else
    f=s.files2copy;
    destpath=fullfile(pwd,'mpm');
end

%% ==========[make dir]=====================================


if exist(destpath)~=7
    mkdir(destpath)
else
    %% ===============================================
    if isgui==1
        
        [~, subdir]=fileparts(destpath);
        
        ButtonName = questdlg(['This might overwrite existing files in the "' subdir '"-folder'], ...
            'Proceed?', ...
            'Yes', 'no,cancel','Yes');
        if  strcmp(ButtonName,'Yes')==1
            disp('..overwrite settings...')
        else
            disp('..cancelled...');
            return
        end
    end
    
    %% ===============================================
    
end



if isempty(f)
    disp('no files selected')
end
disp(['copying files to: ' destpath]);

if isgui==1
   path_resources= u.path_resources;
else
    path_resources=s.path_resources;
end

for i=1:size(f)
    f1=fullfile(path_resources,  f{i,1});
    f2=fullfile(destpath        ,  f{i,1});
    disp(['  ..copying "' f{i,1} '" ..' ]);
    copyfile(f1,f2,'f')
    changeFile(destpath,f{i,1} )
end


%% ======[ modifications ]=========================================

function changeFile(pa, fi)

%% ==========[presettings]=====================================
pathis=pwd;
pa_resource=fullfile(fileparts(which('mpm.m')),'resources');
cd(pa_resource);
tb=mpm_miscsettings;
cd(pathis);

hp=findobj(gcf,'tag','preselection');
presel=hp.String{hp.Value};


%% ===============================================
respa=fullfile(fileparts(which('mpm')),'resources');
if strcmp(fi, 'hmri_local_defaults_mouse.m')
    f1=fullfile(pa,fi);
    a=preadfile(f1); a=a.all;
    
%     ix=regexpi(a,'^\s{0,10}hmri_def.TPM=');
%     ix=find(~cellfun(@isempty,ix));
%     lin=a{ix};
%     icmt=strfind(lin,'%'); 
%     cmt='';
%     if ~isempty(cmt); cmt=lin(cmt(1):end); end
%     m=[' hmri_def.TPM=' '''' fullfile(respa,'mouseTPM_mod.nii') ''';'  cmt];
%     a{ix}=m;
    a2=a;
    a2=replaceconfiguration(a2, 'hmri_def.TPM'   , [ fullfile(respa,'mouseTPM_mod.nii')]);
    
    
    pwrite2file(f1,a2);
elseif strcmp(fi, 'mpm_config.m')  
    %% ===============================================
    
    f1=fullfile(pa,fi);
    a=preadfile(f1); a=a.all;
    a2=a;
    a2=replaceconfiguration(a2, 'mpm.hrmi_defaults'   , fullfile(pa,'hmri_local_defaults_mouse.m'));
    a2=replaceconfiguration(a2, 'mpm.NIFTI_parameters', fullfile(pa,'mpm_NIFTIparameters.xlsx'));
    
    a2=replaceconfiguration(a2, 'mpm.PD_normalizeMask', fullfile(respa,'mask_ventricle.nii'));
    
    path_hmri=tb{strcmp(tb(:,1),presel),2}; %REPLACE PRESELECTED HMRI-PATH
    a2=replaceconfiguration(a2, 'mpm.MPM_path', path_hmri);
    

    %add SPM-path
    [u1 sub]=fileparts(fileparts(fileparts(which('spm.m'))));
    if ~isempty(sub) && strcmp(sub,'antx2')==0
       a2=replaceconfiguration(a2, 'mpm.SPM_path', [ which('spm.m')]  ); 
    end
    
%     char(a2)
  
     pwrite2file(f1,a2);
    
    %% ===============================================
    
end


function a2=replaceconfiguration(a, isearch, repl)
%% ===============================================
% isearch='mpm.hrmi_defaults'
% repl='dum'
ix=regexpi(a,['^\s{0,10}' isearch]);
ix=find(~cellfun(@isempty,ix));
lin=a{ix};

%comment
icmt=strfind(lin,'%');
cmt='         ';
if ~isempty(icmt);
    cmt=[cmt  lin(icmt(1):end)];
end

%variable
b=lin(1:min(strfind(lin,'=')));
if ischar(repl)
    m=[b   '''' repl ''';'  cmt];
elseif isnumeric(repl)
    m=[b   '[' repl '];'  cmt];
end
a2=a;
a2{ix}=m;

    
%% ===============================================

    
    








