
% #wg    mpm    
% 
% 
% #ko [setup]: 
% #b Copy necessary parameter files to user-defined destination folder (mpm-folder)
% The destination-folder, in most cases named "mpm", is assumed to be located in the study folder:
% 
%  DATA STRUCTURE SUGGESTION , EXAMPLE: 
% Sudyfolder: "F:\DATA7\MPM_AGBRANDT" 
% |---dat                         -dat folder wiht example data (each folder is an animal)
% |     |---20220725AB_MPM_18-9 
%       |---20220725AB_MPM_12-4  
% |---raw                          -contain bruker-raw data
% |---mpm                          -mpm-folder (conain the parameter files)
%
% The copied files are:
%     mpm_NIFTIparameters.xlsx     : excelfile with NIFTI-filenames and Paramters such as FA/TR/TE
%                                    Please enter the NIFTI-filenames here
%                                    Paramters such as FA/TR/TE are obtained from the Bruker-raw data and
%                                    inserted automatically
%     mpm_config.m                 : parameters for preprocessing and running the hMRI-toolbox
%                                    Please modify parameters accordingly 
%                                    further description will follow
%     hmri_local_defaults_mouse.m  : default paramters of hMRI-toolbox for mouse in standard space (Allen mouse brain) 
%                                    No need to change these parameters 
% 
% The setup has to be done only once!
% 
% #ko [load configfile]  
% #b Load configfile "mpm_config.m".
% The paramters in mpm_config.m form the global variable "mpm"
% This step is necessary whn matlab is started or the global variable "mpm" is deleted
% 
% 
% % #ko [RUN]: 
% Run all selected processing steps, these are selected steps of the preprocessing (prepoc)
% and hMRI-TBX.
% 
% #m IMPORTANT
% For the prepocessing steps ANTX-toolbox is necessary. 
% For hMRI-TBX-steps, the user is not dependent on the ANTx-toolbox
% If you use the ANTX-TBX, please select the animals from ANTx-main GUI
% If you only want to execute the steps from hMRI-TBX without ANTx-TBX please select the 
% animal folders via "mpm" via button [select animals] 
% 
% 



% % split 4D-files
% f_split4Dfiles();
% 
% %add HDR-description to final files in standardSpace
% f_addHDRdescrition();
% 
% % multiplay by factor 2000
% f_multplyFactor();
% 
% % run model
% f_runMRM_mode1();
% 
% % normalize PD
% f_PDnormalize();


% % obtain bruker parameters
% f_obtainBrukerparameter();
% 
% % copyANDrename files
% f_renamefiles();
% 
% % register turborare to t1/pd/mt
% f_registerTurborare();
% 
% % register to standardspace
%  f_regist2SS();
%  
% % transform images to standard-space
% f_transform2SS();

function mpm(varargin)



%% ===============================================
p=struct();
%  table-PROC1, [ tag  default-selected   callingfile   message]
t1={...
    'obtainbruker'      0   'f_obtainBrukerparameter'   'obtain Bruker parameters'            ['such as TE/TR/FA']
    'renamefiles'       0   'f_renamefiles'             'copyANDrename files'                 ['']
    'register2PD'       0   'f_registerTurborare'       'register turborare to T1/PD/MT'      ['']
    'register2SS'       0   'f_regist2SS'               'register turborare to standardspace' ['']
    'transform2SS'      0   'f_transform2SS'            'transform images to standard-space'  ['']
};

% t1(2:end,2)={0};
p.t1=t1;

%  table-PROC2, [ tag  default-selected   callingfile]
t2={...
    'split4D'        1   'f_split4Dfiles'           'split 4D files to 3D files'    ['']
    'addHDR'         1   'f_addHDRdescrition'       'add HDR-info for hMRI-TBX'     ['']
    'multiply'       1   'f_multplyFactor'          'scale image by factor'         ['']
    'runmodel'       1   ''                         'selected model to run'         ['']
    'normalize'      1   'f_PDnormalize'            'normalize image by mask'       [''] 
};
t2(1:end,2)={0};
p.t2=t2;


p.hmrimodels={'f_runMRM_mode1.m'};
% ==============================================
%%   add local mpm_functions_path
% ===============================================
mpm_path=fileparts(which('mpm.m'));
ix_mpm_path=strfind(path,mpm_path);
if isempty(ix_mpm_path);     addpath((mpm_path));  end

subdirs={'misc'}; %add subdirs
for i=1:length(subdirs)
    this_subdir=fullfile(mpm_path,subdirs{i});
    if isempty(strfind(path,this_subdir))
        addpath(genpath(this_subdir));
    end
end

%% ===============================================

makefig(p);
hide_mdirs();
makeMenu();
% which('ant.m')

% ==============================================
%%   
% ===============================================

function hide_mdirs()
global an
tags={'lb_animaldirs' 'clearAnimals' 'selectAnimals'};
if ~isempty(which('ant.m'))  && ~isempty(an) && ~isempty(antcb('getsubjects'))
    for i=1:length(tags)
        set(findobj(gcf,'tag',tags{i}),'visible','off')
        %               set(findobj(gcf,'tag',tags{i}),'enable','off') ;
        %        set(hb,'visible','off','tag','tx_antx_mdirs');
        
        
    end
    set(findobj(gcf,'tag','tx_antx_mdirs'),'visible','on') ;
end




function makefig(p)

delete(findobj(0,'tag','mpm'));
figure
set(gcf,'menubar','none','tag','mpm','name',['mpm [' mfilename '.m]' ],'NumberTitle','off','color','w','units','norm');
set(gcf,'position',[ 0.4049    0.2633    0.2632    0.4667]);


%% ==========[help]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','help');
set(hb,'position',[0.010714 0.96072 0.10714 0.04]);
set(hb,'callback',@pb_help);

set(hb,'tooltipstring',['get som help' ]);



%% ==========[setup]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','setup');
set(hb,'position',[[0.010714 0.90595 0.10714 0.047619]]);
set(hb,'callback',@setup);

set(hb,'tooltipstring',['SETUP' char(10)...
    'necessary files (two m-files and one excelfile) will be copied to a user-specified folder' char(10) ...
    'These files must be modified to execute further processing steps' char(10) ...
    'This step has to be done only once!']);

%% ==========[load config]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','load config-file');
set(hb,'position',[0.14761 0.90358 0.2 0.047619]);
set(hb,'callback',@loadconfigfile);

set(hb,'tooltipstring',['load configuration-file ("mpm_config.m")' char(10)...
    'load "mpm_config.m"  to execute further processing steps ']);

%% ==========[TXT config-file]=====================================
hb=uicontrol('style','text','backgroundcolor','k','units','norm','foregroundcolor',[0 0 1]);
set(hb,'string','load config-file','tag','tx_configfile');
set(hb,'position',[[0.35077 0.90358 0.65 0.047619]],'foregroundcolor',[0 1 0]);
global mpm
if isempty(mpm)
    set(hb,'string','--config-file not loaded--');
else
     set(hb,'string',mpm.mpm_configfile);
end
set(hb,'tooltipstring',['used configuration-file ("mpm_config.m")' char(10)...
    'If you see "--config-file not loaded--"  --> use "load configfile"-button to load a config-file']);

%% ==========[TXT ANTX-mdir-info]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[1 1 1]);
set(hb,'position',[0.076368 0.0012618 0.9 0.03],'fontweight','bold');
% set(hb,'HorizontalAlignment','left');
set(hb,'string','--','foregroundcolor',[0 0 1],'backgroundcolor','w');
set(hb,'string','INFO: Please select animals via ANTx-main GUI!');
set(hb,'visible','off','tag','tx_antx_mdirs');

% ==============================================
%%   animla dirs
% ===============================================
%% ==========[button select animals]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','select animals');
set(hb,'position', [0.0024907 0.20125 0.2 0.047619]);
set(hb,'callback',@selectAnimals,'tag','selectAnimals');

set(hb,'tooltipstring',['select animals (paths)  ' char(10)...
    'selected animals will be shown in the animal-listbox  and are ready to process']);

%% ==========[animals-listbox]=====================================
hb=uicontrol('style','listbox','backgroundcolor','w','units','norm');
% set(hb,'string','select animals');
set(hb,'position', [0 0 1 0.2]);
set(hb,'tag','lb_animaldirs');
% set(hb,'callback',@selectAnimals);

set(hb,'tooltipstring',['animal-listbox ' char(10)...
    'listbox contains path of animals to process']);

%% ==========[button clear listbox]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','x','fontsize',7);
set(hb,'position', [0.20565 0.20125 0.04 0.04]);
set(hb,'callback',@clearAnimals,'tag','clearAnimals');

set(hb,'tooltipstring',['clear animal-listbox ' char(10)...
    '']);


% ==============================================
%% [1]  preproc
% ===============================================
%% ==========[TXT status]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[0 0 1]);
set(hb,'position',[0.026237 0.85834 0.37 0.03],'fontweight','bold');
% set(hb,'HorizontalAlignment','left');
set(hb,'string','Preproc','foregroundcolor',[0 0 1],'backgroundcolor','w');

%% ==========[check select all]=====================================
hb=uicontrol('style','check','backgroundcolor',[0.9451    0.9686    0.9490],'units','norm');
set(hb,'string','select all');
set(hb,'position',[0.0077676 0.8 0.4 0.047]);
set(hb,'callback',{@selectall_1});
set(hb,'tag','selectall_1');
if sum(cell2mat(p.t1(:,2)))==size(p.t1,1)
    set(hb,'value',1);
end
set(hb,'tooltipstring',['select/deselect all steps' ]);


%==========[obtainbruker]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','get BrukerParams');
set(hb,'position',[0.01 0.75 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','obtainbruker');
set(hb,'value',p.t1{strcmp(p.t1(:,1), hb.Tag),2});

set(hb,'tooltipstring',['get Bruker parameters such as FA/TR/TE from visu_pars of Bruker raw data ' char(10)...
    'and save this information in the Excelfile ("mpm_NIFTIparameters.xlsx")']);

%==========[renamefiles]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','rename files');
set(hb,'position',[0.01 0.7 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','renamefiles');
set(hb,'value',p.t1{strcmp(p.t1(:,1), hb.Tag),2});

set(hb,'tooltipstring',['rename files ' char(10)...
    'and use fixed filenames']);

%==========[register2PD]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','register turborare to T1/PD/MT');
set(hb,'position',[0.01 0.65 0.43 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','register2PD');
set(hb,'value',p.t1{strcmp(p.t1(:,1), hb.Tag),2});

set(hb,'tooltipstring',['register turborare image (t2w.nii) to PD/T1/MT  images ' char(10)...
    'The output is "t2.nii".']);

%==========[register2SS]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','register to SS');
set(hb,'position',[0.01 0.6 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D;'})
set(hb,'tag','register2SS');
set(hb,'value',p.t1{strcmp(p.t1(:,1), hb.Tag),2});

set(hb,'tooltipstring',['register the PD/T1/MT-registered turborare image ("t2.nii") to standard-space. ' char(10)...
    'For mouse the Allen mouse brain is the standard-space']);

%==========[transform2SS]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','transform  to SS');
set(hb,'position',[0.01 0.55 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D;'})
set(hb,'tag','transform2SS');
set(hb,'value',p.t1{strcmp(p.t1(:,1), hb.Tag),2});

set(hb,'tooltipstring',['transform other images to standard-space. ' char(10)...
    'These images are for instance PD/T1/MT']);


% ==============================================
%% [2]  HMRI-TBX
% ===============================================

%% ==========[TXT status]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[0 0 1]);
set(hb,'position',[0.51963 0.85834 0.37 0.03],'fontweight','bold');
% set(hb,'HorizontalAlignment','left');
set(hb,'string','hMRI-TBX','foregroundcolor',[0 0 1],'backgroundcolor','w');


%% ==========[check select all]=====================================
hb=uicontrol('style','check','backgroundcolor',[0.9451    0.9686    0.9490],'units','norm');
set(hb,'string','select all');
set(hb,'position',[0.5 0.8 0.4 0.047]);
set(hb,'callback',{@selectall_2});
set(hb,'tag','selectall_2');
if sum(cell2mat(p.t2(:,2)))==size(p.t2,1)
    set(hb,'value',1);
end
set(hb,'tooltipstring',['select/deselect all steps' ]);

%==========[split 4dfiles]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','split 4D files');
set(hb,'position',[0.5 0.75 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','split4D');
set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['convert 4D-files to separate 3D-files ' char(10)...
    'This step assumes that the 4D-files are already in standard-space ']);

%==========[add HDR-description]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','add HDR-description');
set(hb,'position',[0.5 0.7 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','addHDR');
set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['add NIFTI-header description ' char(10)...
    'The header description field is written with the Bruker-parameters such as FA/ME/MT ' char(10)...
    'This step is mandatory to run the hMRI-TXB.']);

%==========[multiply factor]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','multiply by factor');
set(hb,'position',[0.5 0.65 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D'});
set(hb,'tag','multiply');
set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['multiply image data of PD/T1/MT with a value  ' char(10)...
    'This step increases the dynamic range of the image']);

%==========[run model1]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','run Model (estimate)');
set(hb,'position',[0.5 0.6 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D;'})
set(hb,'tag','runmodel');
set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['run this hMRI-model  ' ]);

%==========[estimation models]=====================================
hb=uicontrol('style','popupmenu','backgroundcolor','w','units','norm');
set(hb,'string',p.hmrimodels);
set(hb,'position',[0.54074 0.54646 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D;'})
set(hb,'tag','hmrimodels');
% set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['select one of the hMRI-models ' char(10)...
    'Further info will be followed.']);

%==========[normalize]=====================================
hb=uicontrol('style','radio','backgroundcolor','w','units','norm');
set(hb,'string','normalize');
set(hb,'position',[0.5 0.50 0.4 0.047]);
% set(hb,'callback',{@proc2,'split4D;'})
set(hb,'tag','normalize');
set(hb,'value',p.t2{strcmp(p.t2(:,1), hb.Tag),2});

set(hb,'tooltipstring',['normalize "A"/intensity image using a reference mask (binary image)  ' char(10)...
    'The resulting image depicts values (percentages) w.r.t. the ROI of the reference mask']);


%% ==========[Help model-button]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','info');
set(hb,'position',[[0.94178 0.551 0.057 0.044]]);
set(hb,'callback',@pb_helpmodel,'fontsize',7);

set(hb,'tooltipstring',['get hMRI-model info  ' char(10)...
    '']);

% ==============================================
%%   other fig-controls
% ===============================================


%% ==========[RUN]=====================================
hb=uicontrol('style','pushbutton','backgroundcolor','w','units','norm');
set(hb,'string','RUN');
set(hb,'position',[[0.51699 0.356 0.10714 0.047619]]);
set(hb,'callback',@run);

set(hb,'tooltipstring',['Execute all selected steps  ' char(10)...
    '']);

%% ==========[TXT status]=====================================
hb=uicontrol('style','text','units','norm','foregroundcolor',[0 0 1]);
set(hb,'position',[[0.62517 0.362 0.5 0.03]]);
set(hb,'HorizontalAlignment','left');
set(hb,'string','status: idle','tag','tx_status','foregroundcolor',[0 0 1],'backgroundcolor',repmat(1,[1 3]) );


% ==============================================
%%  version
% ===============================================
%====INDICATE LAST UPDATE-DATE ========================
% vstring=strsplit(help('antver'),char(10))';
% idate=max(regexpi2(vstring,' \w\w\w 20\d\d (\d\d'));
% dateLU=['ANTx2  vers.' char(regexprep(vstring(idate), {' (.*'  '  #\w\w ' },{''}))];
dateLU=mpmcb('version');
% dateLU=['v'  datestr(now)];
h = uicontrol('style','pushbutton','units','normalized','position',[.94 .65 .08 .05],'tag','txtversion',...
    'string',dateLU,'fontsize',5,'fontweight','normal',...
    'tooltip',['date of last update' char(10) '..click to see last updates [mpmver.m]']);
% set(h,'position',[.2 .65 .08 .02],'fontsize',6,'backgroundcolor','w','foregroundcolor',[.7 .7 .7])
set(h,'position',[0.62 0.96786 0.3 0.027],'fontsize',7,'backgroundcolor','w','foregroundcolor',[0.9294    0.6941    0.1255],...
    'horizontalalignment','left','callback',{@callmpmver});

%% ===============================================
% update-pushbutton :get update ...no questions ask
%% ===============================================
h = uicontrol('style','pushbutton','units','normalized','position',[.94 .65 .04 .05],...
    'tag','update_btn',...
    'string','','fontsize',13,  'callback',{@updateTBXnow},...
    'tooltip', ['<html><b>download latest updates from Github</b><br>forced updated, no user-input<br>'...
    '<font color="green"> see contextmenu for more options'],...
    'backgroundcolor','w');
set(h,'position',[0.92068 0.96786 0.036939 0.033331]);
set(h,'units','pixels');
posi=get(h,'position');
set(h,'position',[posi(1:2) 14 14]);
set(h,'units','norm');
icon=fullfile(fullfile(fileparts(which('mpm.m')),'misc'),'Download_16.png');
[e map]=imread(icon)  ;
set(h,'cdata',e);

cmm=uicontextmenu;
uimenu('Parent',cmm, 'Label','check update-status',             'callback', {@updateTBX_context,'info' });
uimenu('Parent',cmm, 'Label','force update',                    'callback', {@updateTBX_context,'forceUpdate' } ,'ForegroundColor',[1 0 1],'separator','on');
uimenu('Parent',cmm, 'Label','show last local changes (files)', 'callback', {@updateTBX_context,'filechanges_local' } ,'ForegroundColor',[.5 .5 .5],'separator','on');
uimenu('Parent',cmm, 'Label','help: update from GitHUB-repo' ,  'callback', {@updateTBX_context,'help' } ,'ForegroundColor',[0 .5 0],'separator','on');
set(h,'UIContextMenu',cmm);


% ==============================================
%%   add userdata
% ===============================================

set(gcf,'userdata',p);


function makeMenu()
 f = uimenu('Label',repmat(' ',[1 50]));
f = uimenu('Label','Preproc');
    uimenu(f,'Label','estimate pre-orientation t2w to T1/PD/MT','callback',{@cb_menu,'estimPreorient'});
 


% ==============================================
%%   select all (preproc)
% ===============================================
function selectall_1(e,e2)
%% ===============================================
u=get(gcf,'userdata');
hc=findobj(gcf,'tag','selectall_1');
val=get(hc,'value');
for i=1:length(u.t1(:,1))
   set( findobj(gcf,'tag',u.t1{i,1}) ,'value',val);
end
% ==============================================
%%   select all (postproc)
% ===============================================
function selectall_2(e,e2)
%% ===============================================
u=get(gcf,'userdata');
hc=findobj(gcf,'tag','selectall_2');
val=get(hc,'value');
for i=1:length(u.t2(:,1))
   set( findobj(gcf,'tag',u.t2{i,1}) ,'value',val);
end
%% ===============================================






% ==============================================
%%   subs
% ===============================================
function selectAnimals(e,e2)
%===================================================================================================
%% ===============================================

% [dirs] = spm_select('FPList',pwd,'dir')
msg='select animal-directories';
 [t,sts] = spm_select(inf,'dir',msg','', pwd);
 if ~isempty(t)
    mdirs=cellstr(t);
    set(findobj(gcf,'tag','lb_animaldirs'),'string',mdirs);
 end
 
%% ===============================================
function clearAnimals(e,e2)
set(findobj(gcf,'tag','lb_animaldirs'),'string','');

% selectAnimals


function loadconfigfile(e,e2)
[fi pa]=uigetfile(fullfile(pwd,'*.m'),'load configuration-file["mpm_config.m"]');
if isnumeric(fi); 
    return 
else
    ht=findobj(gcf,'tag','tx_configfile');
    set(ht,'string','..loading..');
    drawnow; pause(0.3);
    mpm_configfile=fullfile(pa,fi);
    f_getconfig(mpm_configfile);
    u=get(gcf,'userdata');
    u.mpm_configfile=mpm_configfile;
    set(gcf,'userdata',u);
    
    
    
     set(ht,'string',mpm_configfile);
    drawnow; pause(0.3)
    
    %set SPM-path if not available
    if isempty(which('spm.m'))
        global mpm
       if exist(mpm.SPM_path)==7
        addpath(mpm.SPM_path);
       end
    end
end

function pb_helpmodel(e,e2)
hb=findobj(gcf,'tag','hmrimodels');
funfile=char(hb.String(hb.Value));
uhelp([funfile],0);



function pb_help(e,e2)
uhelp([mfilename '.m'],0);

%% =============[set-up]==================================
function setup(e,e2)


f_setup();

% ==============================================
%%   function RUN
% ===============================================

function run(e,e2)
%% ==============================================
u=get(gcf,'userdata');

%% =========[preproc]======================================

curval=[];
for i=1:size(u.t1,1)
 curval(i,1)=get(findobj(gcf,'tag',u.t1{i,1}),'value');
end
t1=u.t1;
t1(:,2)=num2cell(curval);
t1(:,3)=regexprep(t1(:,3),'.m$','');
t1=t1(curval==1,:);
%% ======[hmriProc]=========================================
curval=[];
for i=1:size(u.t2,1)
 curval(i,1)=get(findobj(gcf,'tag',u.t2{i,1}),'value');
end
t2=u.t2;
t2(:,2)=num2cell(curval);
%model
ix=strcmp(t2(:,1),'runmodel');
hm=findobj(gcf,'tag','hmrimodels');
modelfun=hm.String{hm.Value};
t2{ix,3}=modelfun;
t2(:,3)=regexprep(t2(:,3),'.m$','');
t2=t2(curval==1,:);
%% ===============================================


% ___mdirs__
hm=findobj(gcf,'tag','lb_animaldirs');
mdirs=get(hm,'string');
if isempty(char(mdirs))
    mdirs=[];
end

funclist=[t1(:,3); t2(:,3)];
% disp(funclist);


% return

% clc; disp(t2);
%% ===============================================
if isempty(funclist);
    disp(['no functions selected']);
    return;
end

is_mdirsOK=0;
if ~isempty(mdirs)
    is_mdirsOK=1;
end
if ~isempty(which('ant.m'))
    mdirs_antx=antcb('getsubjects');
    if ~isempty(mdirs_antx)
        is_mdirsOK=1;
    end
end


if is_mdirsOK==0
    disp(['no animals selected..(selection via mpm or ANTX-mainGUI  )']);
    return;
end
    
    

hf=findobj(findobj(0,'tag','mpm'),'tag','tx_status');
set(hf,'string','busy','tag','tx_status','foregroundcolor',[1 0 1],'backgroundcolor',[1 .84 0] );
drawnow;

% funclist=t2(:,3);
% clc
for i=1:size(funclist,1)
    set(hf,'string',['busy ' funclist{i} ],'tag','tx_status','foregroundcolor',[1 0 1],'backgroundcolor',[1 .84 0] );
    drawnow;
    if isempty(mdirs)
        feval(funclist{i}); %with ANTX-tbx
    else
        feval(funclist{i},mdirs); %with ANTX-tbx
    end
    
end

set(hf,'string','status: idle','tag','tx_status','foregroundcolor',[0 0 1],'backgroundcolor',repmat(1,[1 3]) );
drawnow;






function cb_menu(e,e2,task)


if strcmp(task,'estimPreorient')
    f_estimPreorient();
    
end


function callmpmver(e,e2)
mpmver;



% ==============================================
%%   update tbx via button-contextMENU, no user-questions
% ===============================================
function updateTBX_context(e,e2,task)


currpath=fileparts(which('mpm.m'));
cname   =getenv('COMPUTERNAME');
msg_myMachine='The source machine can''t be updated from Github';
if strcmp(task,'help')
    help updatempm
elseif strcmp(task,'info')
    if strcmp(cname,'STEFANKOCH06C0')==1 && strcmp(currpath,'F:\mpm')
        disp(msg_myMachine);  %my computer---not allowed
    else
        updatempm('info');
    end
elseif strcmp(task,'forceUpdate')
    if strcmp(cname,'STEFANKOCH06C0')==1 && strcmp(currpath,'F:\mpm')
        disp(msg_myMachine);  %my computer---not allowed
    else
        updatempm(3);
    end
elseif strcmp(task,'filechanges_local')
    if strcmp(cname,'STEFANKOCH06C0')==1 && strcmp(currpath,'F:\mpm')
        disp(msg_myMachine);  %my computer---not allowed
    else
        updatempm('changes');
    end
end
% ==============================================
%%   update-btn
% ===============================================

function updateTBXnow(e,e2)


currpath=fileparts(which('mpm.m'));
cname=getenv('COMPUTERNAME');
if  strcmp(cname,'STEFANKOCH06C0')==1 && strcmp(currpath,'F:\mpm');
    disp('The source machine can''t be updated from Github');  %my computer---not allowed
else
    thispa=pwd;
    go2pa =fileparts(which('mpmver.m'));
    cd(go2pa);
    try
        w=git('log -p -1');                    % obtain DATE OF local repo
        w=strsplit(w,char(10))';
        date1=w(min(regexpi2(w,'Date: ')));
    catch
        cd(thispa);
    end
    
    updatempm(2);                              % UPDAETE
    mpmtcb('versionupdate');
    
    try
        w=git('log -p -1');                  % obtain DATE OF local repo
        w=strsplit(w,char(10))';
        date2=w(min(regexpi2(w,'Date: ')));
    catch
        cd(thispa);
    end
    
    cd(thispa);
    if strcmp(date1,date2)~=1   %COMPARE date1 & date2 ...if changes--->reload tbx
        q=updatempm('changes');
        if ~isempty(find(strcmp(q,'mpm.m')));
            disp(' mpm-main gui was modified: reloading GUI');
            %antcb('reload');
            mpm;
        end
    end
end

