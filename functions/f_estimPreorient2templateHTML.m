% get pre-orientation T1/MT/PD to template ('AVGT.nii')  ..HTMLversion
function f_estimPreorient2templateHTML(mdirs,varargin)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
    f_estimPreorient2templateHTML({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
    
    
    f_estimPreorient2templateHTML([],'sel');
end
%% =============  get PARAMETER ==================================
f_getconfig();
global mpm
a2=mpm.niftis.a2;
%% =========[animal dirs]======================================
if exist('mdirs')==1 && ~isempty(mdirs)
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
mdirs=cellstr(mdirs);
% ==============================================
%%   vars in
% ===============================================

if ~isempty(varargin)
    
    %________________________________________________
    %%  select files
    %________________________________________________

    if ischar(varargin{1}) && strcmp(varargin{1},'sel')
        pa=mdirs;
        fi2={};
        for i=1:length(pa)
            [files,~] = spm_select('FPList',pa{i},['.*.nii$']);
            if ischar(files); files=cellstr(files);   end;
            fis=strrep(files,[pa{i} filesep],'');
            fi2=[fi2; fis];
        end
        li=unique(fi2);
        
%         fx=char(mpm.NIFTI_parameters);
%         [~,~,a0]=xlsread(fx);
%         a0=cellfun(@(a){[ num2str(a)]}, a0 );
%         a=a0(2:end,:);
%         a(strcmp(a(:,2),'NaN'),:)=[];
       t         = mpm.niftis.f; %niftitable
        li=li(find(ismember(li,t(:,2))));
        
        %mov='t2w.nii';%g.files{strcmp(g.files(:,1),'t2w'),2};
        %mov=t{find(strcmp(t(:,1),'t2w')==1),2};
        mov=fullfile(fullfile(fileparts(an.datpath),'templates','AVGT.nii'));
        if exist(mov)~=2
            sub_importTemplate();
        end
        
        if      ~isempty(find(strcmp(t(:,1),'T1')==1))
            fix=t{find(strcmp(t(:,1),'T1')==1),2};
        elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
            fix=t{find(strcmp(t(:,1),'MT')==1),2};
        elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
            fix=t{find(strcmp(t(:,1),'PD')==1),2};
        end
        
        
        
        x=struct();
        p={...
        'inf1'        'get pre-orientation from "AVGT.nii" to "T1/MT/PD"-image '                           '' ''
        'targetFile'      fix      'target image [for MPM: this should be either the T1/MT or PD image ]'  {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','select target-image'}
        'sourceFile'      mov      'source image [for MPM: this should be "AVGT.nii"]'           'f' % {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
        
            };
        p=paramadd(p,x);
        
        
        
        
        % %% show GUI
        showgui=1;
        if showgui==1
            hlp=help(mfilename); hlp=strsplit2(hlp,char(10))';
            [m z ]=paramgui(p,'uiwait',1,'close',1,'editorpos',[.03 0 1 1],'figpos',[.15 .3 .4 .2 ],...
                'title',['***'  mfilename '***'],'info',{@uhelp,[ mfilename '.m']});
            try
                fn=fieldnames(z);
            catch
                return
            end
            z=rmfield(z,fn(regexpi2(fn,'^inf\d')));
        else
            z=param2struct(p);
        end
    end
    
    z.targetFile=char(z.targetFile);
    z.sourceFile=char(z.sourceFile);
    
    clear p;
    
    
end

%% ==============[get variables ]===================
t         = mpm.niftis.f; %niftitable
% preorient = mpm.t2w_preorient;
%% ===============================================

if exist('z')==1
%     mov=char(z.sourceFile);
%     fix=char(z.targetFile);
    
%test-2
    fix=char(z.sourceFile);
    mov=char(z.targetFile);
else
    
    %     mov=fullfile(fullfile(fileparts(an.datpath),'templates','AVGT.nii'));
    %     if      ~isempty(find(strcmp(t(:,1),'T1')==1))
    %         fix='t1.nii' ;
    %     elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
    %         fix='MT.nii' ;
    %     elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
    %         fix='PD.nii' ;
    %     end
    
    %test2
    fix=fullfile(fullfile(fileparts(an.datpath),'templates','AVGT.nii'));
    if exist(fix)~=2
        sub_importTemplate(); 
    end
    if      ~isempty(find(strcmp(t(:,1),'T1')==1))
        mov='t1.nii' ;
    elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
        mov='MT.nii' ;
    elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
        mov='PD.nii' ;
    end
    
    
end

cprintf('*[0 0 1]',[ ['estimate pre-orientation: "' strrep(mov,filesep,[filesep filesep]) '"  to "' strrep(fix,filesep,[filesep filesep]) '"' ] '\n'] );


% ==============================================
%%   rot:  1.5708 -6.1232e-17 1.5708
% ===============================================
px=mdirs{1};
% #g example
%     p.f1=fullfile(px,'t2.nii'); % SOURCE
%     p.f2=fullfile(px,'test_t1_first_001.nii');   % REFIMAGE


% f1=fullfile(px,mov);%,'t2w.nii');   % SOURCE
% f1=mov;
% f2=fullfile(px,fix);%'t1_fistIMG_001.nii'); % REFIMAGE

% test-2
f1=fullfile(px,mov);
f2=fix;%'t1_fistIMG_001.nii'); % REFIMAGE


% ==============================================
%%   use function
% ===============================================
htmlfile=getorientationHtml(f1,f2);
disp(['HTMLfile:' htmlfile]);


%% ===============================================
col=[0.4941    0.4941    0.4941];
colstr=[ '[' num2str(col) ']'];
cprintf('*[0 .5 0]',[ 'please inspect HTML-file in "checks"-folder'  '\n'] );
cprintf([colstr],[ 'If needed, please modify your ANTx2-project-file'  '\n'] );
cprintf([colstr],[ 'In the ANTx2-project-file set the variable "orientType": '  '\n'] );
cprintf([colstr],[ '  use either the "rotTable-Index" (numeric value) '   '\n'] );
cprintf([colstr],[ '  or use the three 3 rotations (as string)' '\n'] );
disp([ ' ... don''t forget to reload the project  ..e.g. via: antcb(''reload'')'  ] );

%% ===============================================




return

h1=spm_vol(f1);
h2=spm_vol(f2);

do_delete=1;
delfiles={};
if length(h1)~=1
    [ha a]=rgetnii(f1);
    hx=ha(1);
    x=a(:,:,:,1);
    f1n=fullfile(px, stradd(mov,'__1stimage',2));
    rsavenii(f1n, hx, x,64);
    if do_delete==1
        delfiles{end+1,1}=f1n;
    end
else
    f1n=f1;
end
if length(h2)~=1
    [ha a]=rgetnii(f2);
    hx=ha(1);
    x=a(:,:,:,1);
    f2n=fullfile(px, stradd(fix,'__1stimage',2));
    rsavenii(f2n, hx, x,64);
    if do_delete==1
        delfiles{end+1,1}=f2n;
    end
else
    f2n=f2;
end

%% ===============================================
cprintf('*[0 0 1]',[ 'GET PREORIENTATION'  '\n'] );
cprintf('[0 0 1]',[ '1) change each image to CORONAL orientation [dim1],[dim2] or [dim3] button'  '\n'] );
cprintf('[0 0 1]',[ '2) set 3 landmarks in each volume'  '\n'] );
disp( ['     2.1) top(superior) of OLFACT. BULBUS']);
disp( ['     2.2) superior part of MIDLINE STRUCTURE']);
disp( ['     2.3) inferor part of MIDLINE STRUCTURE and onthe same plane as (2)']);
disp( ['       -ideally, the 3 points (a) anatomically match in both images ']);
disp( ['                              (b) must have a large large distance from each other ']);
cprintf('[0 0 1]',[ '3) Select MRicron from pulldown and hit [check]-button to inspect the overlay.'  '\n'] );
disp( ['             -alternatively, just and hit [check]-button (without MRicron)  ']);
cprintf('[0 0 1]',[ '4) If the overlay is "ROUGHLY" OK, hit [CLOSE]-button.'  '\n'] );
%% ===============================================


p.f1=f1n;
p.f2=f2n;
p.info=''; % info
p.info='';
p.showlabels=0;
p.wait=1;              % busy mode
s=manuorient3points(p);  % execute function

%% ===============================================

if ~isempty(s)
    rnd_dec=4;
    s.rot_round=round(s.rot,rnd_dec);
   
    rot_str=sprintf(['%1.' num2str(rnd_dec) 'g '],s.rot_round);
    rot_str(end)=[];  %remove trailing space
 
    disp(['rotation: ''' rot_str  '''' ]);
    disp(['suggested rot-ID: ['  num2str(s.rot_ixd(1)) ']   from rottable:  ' s.funtable ]);
    cprintf('*[0 .5 0]',[ 'If needed, please modify your ANTx2-project-file'  '\n'] );
    cprintf('[0 .5 0]',[ 'In the ANTx2-project-file set the variable "orientType": '  '\n'] );
    cprintf('[0 .5 0]',[ '  either to: ''' rot_str  ''''  '   ... i.e. three 3 rotations (as string)' '\n'] );
    cprintf('[0 .5 0]',[ '  or to    : ' '['  num2str(s.rot_ixd(1)) ']'  '               ... i.e. the rotation-ID from rotation-table (findrotation2), (as numeric value)' '\n'] );
    disp([ ' ... don''t forget to reload the project'] );

end
%% ===============================================


if do_delete==1
    for i=1:length(delfiles)
        delete(delfiles{i})
    end
end

%% ===============================================
% 1.5708 -6.1232e-17 1.5708

% 
% cprintf('*[0 0 1]',[ 'Please insert the three values of "ROTATONS" into "mpm.t2w_preorient" in the file  [mpm_config.m]'  '\n'] );
% showinfo2(['mpm-config file:' ],mpm.mpm_configfile);






function  sub_importTemplate();
     
%% ===============================================

cprintf('*[0 0 1]',[ 'Templates do not exist...import templates...PLEASE WAIT...'  '\n'] );
antcb('copytemplates');
%% ===============================================






