% obtain pre-orientation  t2w to T1/MT/PD  HTML-version
function f_estimPreorientHTML(mdirs,varargin)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
    f_estimPreorientHTML({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
    
    
    f_estimPreorientHTML(mdirs)
    
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
if isempty(char(mdirs))
    mdirs=antcb('getallsubjects');
end
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
        mov=t{find(strcmp(t(:,1),'t2w')==1),2};
        
        if      ~isempty(find(strcmp(t(:,1),'T1')==1))
            fix=t{find(strcmp(t(:,1),'T1')==1),2};
        elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
            fix=t{find(strcmp(t(:,1),'MT')==1),2};
        elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
            fix=t{find(strcmp(t(:,1),'PD')==1),2};
        end
        
        
        
        x=struct();
        p={...
            
        'targetFile'      fix                'target image, (static/reference image)'  {@selector2,li,{'TargetImage'},'out','list','selection','single','position','auto','info','select target-image'}
        'sourceFile'      mov                'source image, (moved image)'             {@selector2,li,{'SourceImage'},'out','list','selection','single','position','auto','info','select source-image'}
        
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
    mov=char(z.sourceFile);
    fix=char(z.targetFile);
    
else
    
    %mov='t2w.nii';%g.files{strcmp(g.files(:,1),'t2w'),2};
    mov=t{find(strcmp(t(:,1),'t2w')==1),2};
    
    if      ~isempty(find(strcmp(t(:,1),'T1')==1))
        %fix='t1.nii' ;
        fix=t{find(strcmp(t(:,1),'T1')==1),2};
    elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
        %fix='MT.nii' ;
        fix=t{find(strcmp(t(:,1),'MT')==1),2};
    elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
        %fix='PD.nii' ;
        fix=t{find(strcmp(t(:,1),'PD')==1),2};
    end
end

cprintf('*[0 0 1]',[ ['estimate pre-orientation: "' mov '"  to "' fix '"' ] '\n'] );


% ==============================================
%%   rot:  1.5708 -6.1232e-17 1.5708
% ===============================================
px=mdirs{1};
% #g example
%     p.f1=fullfile(px,'t2.nii'); % SOURCE
%     p.f2=fullfile(px,'test_t1_first_001.nii');   % REFIMAGE


f1=fullfile(px,mov);%,'t2w.nii');   % SOURCE
f2=fullfile(px,fix);%'t1_fistIMG_001.nii'); % REFIMAGE



% ==============================================
%%   use function
% ===============================================
htmlfile=getorientationHtml(f1,f2);
disp(['HTMLfile:' htmlfile]);


%% ===============================================
% col=[0.4941    0.4941    0.4941];
col=[1 0 1];
colstr=[ '[' num2str(col) ']'];
cprintf('*[0 .5 0]',[ 'please inspect HTML-file in "checks"-folder'  '\n'] );

cprintf(['*' colstr],[ 'If needed, please modify the'] );
cprintf(['*0.6353    0.0784    0.1843'],[' [mpm_config.m]' ] );
cprintf(['*' colstr],['-file'  '\n'] );

cprintf(['*' colstr],[ '..i.e. set the three rotations (as string) in "mpm.t2w_preorient" in the file  [mpm_config.m]'    '\n'] );
disp([ ' ... don''t forget to reload the mpm-configfile ..e.g. via: mpm(''reload'')'    ] );

%% ===============================================



