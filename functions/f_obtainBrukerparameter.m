
%obtain bruker-parameter
function f_obtainBrukerparameter(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_obtainBrukerparameter({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
end
%% =============  get PARAMETER ==================================
f_getconfig();
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
%% ===============================================

% disp(mdirs);
% [a2  c]=f_getparameters();

files=a2(:,1:2);
files=files(strcmp(files(:,2),'NaN')==0,:);


if exist('paras')~=1 || isempty(paras)
    paras={...
        'VisuAcqEchoTime'
        'VisuAcqFlipAngle'
        'VisuAcqRepetitionTime'
        };
end
pa=mdirs{1};

tb=getbrukerparamss(files, paras,pa);


writeXLSfile(mpm.niftis,tb);

%% ===============================================
function writeXLSfile(c,tb);

%% ===============================================
paras={...
        'VisuAcqEchoTime'          'TE_ms'
        'VisuAcqFlipAngle'         'FA_deg'
        'VisuAcqRepetitionTime'    'TR_ms'
        };


tags={tb(:).nametag};
d=c.a;


for i=1:length(tags)
    ix=find(strcmp(d(:,1),tags{i}));
    for j=1:size(paras,1)
        ic=find(strcmp(c.ha,paras{j,2}));
        ms=getfield(tb(i),paras{j,1});
        ms=regexprep(ms,'\s+',',');
        d{ix,ic}=ms;
    end
end
%% ===========write EXCELFILE ====================================
isExcel=1;
try
    e=matlab.io.internal.getExcelInstance;
catch
    isExcel=0;
end

f2=c.xlsfile;
%% ============[get last modification in secs]===================================
% BLOCK WRITING EXCEL IF diff last MODIF-IME IS < block_time_sec
so=dir(f2);
t1=datevec(so.datenum);
t2=datevec(now);
difftime_sec=round(etime(t2,t1));
block_time_sec=5; 

% difftime_sec>block_time_sec;

%% ===============================================
if difftime_sec>block_time_sec
    if isExcel==1
        [~,sheets]=xlsfinfo(f2);
        pwrite2excel(f2,{1 sheets{1}},c.ha,[],d);
    else
        %% ===============================================
        ht=c.ha;
        ht=regexprep(ht,{'(.*\)' ,'\s+' },'');
        t=cell2table(d,'VariableNames',ht);
        writetable(t,f2,'Sheet',1);
    end
    showinfo2('VISU-parameters added: ' ,f2);
else
    disp(['excelfile..no modifications, because last modification is < ' num2str(difftime_sec) 's ago!']);
end
%% ===============================================









% ==============================================
%%
% ===============================================
function tb=getbrukerparamss(files, paras,pa)
k=dir(fullfile(pa,'logImport_*.log'));

clear tb
for j=1:length(k)
    lf=fullfile(pa,k(j).name);
    a=preadfile(lf); a=a.all;
    
    for i=1:length(files)
        f1=fullfile(pa,files{i,2});
        ix=find(~cellfun(@isempty,strfind(a,f1)));
        for u=1:length(ix)
            a2=a{ix(u)};
            a3=strsplit(a2,' ');
            
            pab=fileparts(a3{2});%brukerPath
            
            fv=fullfile(pab,'visu_pars');
            t=getparas(fv,paras);
            fn=fieldnames(t);
            t.nametag=files{i,1};
            t.name   =files{i,2};
            t=orderfields(t, ['nametag';'name';fn]);
            
            
            
            tb(i)=t;
        end
        
    end
end





%% ===============================================

function ts=getparas(file,paras)

% file='F:\data7\MPM_mouse\read_brukerParameter\visu_pars'
q=preadfile(file); q=q.all;

% paras={...
%     'VisuAcqEchoTime'
%     'VisuAcqFlipAngle'
%     'VisuAcqRepetitionTime'
%     }
t={};
ts=struct();
for i=1:size(paras,1)
    % q2=strjoin(q,char(10));
    % i1=strfind(q2,paras{1})
    
    u=regexpi2(q,[ '##\$' paras{i} '=']);
    if ~isempty(strfind(q{u},')'))
        t0=q(u+1);
    else
        t0=regexprep(q{u},'.*=','');
    end
%     t(end+1,:)= ...
%         [paras(i)  t0];
    ts=setfield(ts,paras{i},char(t0));
    
end

%% ===============================================
%
% in:
% visu_pars

%
% ##$VisuAcqEchoTime=( 8 )
% 2.7 5.7 8.7 11.7 14.7 17.7 20.7 23.7
%
%
% ##$VisuAcqFlipAngle=45
%
%
% ##$VisuAcqFlipAngle=90
%
%
% ##$VisuAcqRepetitionTime=( 1 )
% 35
%
% ##$VisuAcqFlipAngle=28



% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%      D
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% file                 4thDim     dim             descrip
% x_T1.nii             8          164,212,158
% x_T1_00001.nii       1          164,212,158     3T 3D GR TR=35ms/TE=2.70ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00002.nii       1          164,212,158     3T 3D GR TR=35ms/TE=5.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00003.nii       1          164,212,158     3T 3D GR TR=35ms/TE=8.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00004.nii       1          164,212,158     3T 3D GR TR=35ms/TE=11.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00005.nii       1          164,212,158     3T 3D GR TR=35ms/TE=14.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00006.nii       1          164,212,158     3T 3D GR TR=35ms/TE=17.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00007.nii       1          164,212,158     3T 3D GR TR=35ms/TE=21.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1_00008.nii       1          164,212,158     3T 3D GR TR=35ms/TE=23.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_T1phase.nii        8          164,212,158
% x_c_MT.nii           6          164,212,158
% x_c_MT_00001.nii     1          164,212,158     3T 3D GR TR=35ms/TE=2.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MT_00002.nii     1          164,212,158     3T 3D GR TR=35ms/TE=5.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MT_00003.nii     1          164,212,158     3T 3D GR TR=35ms/TE=8.70ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MT_00004.nii     1          164,212,158     3T 3D GR TR=35ms/TE=11.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MT_00005.nii     1          164,212,158     3T 3D GR TR=35ms/TE=14.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MT_00006.nii     1          164,212,158     3T 3D GR TR=35ms/TE=17.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_MTphase.nii      6          164,212,158
% x_c_PD.nii           8          164,212,158
% x_c_PD_00001.nii     1          164,212,158     3T 3D GR TR=35ms/TE=2.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00002.nii     1          164,212,158     3T 3D GR TR=35ms/TE=5.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00003.nii     1          164,212,158     3T 3D GR TR=35ms/TE=8.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00004.nii     1          164,212,158     3T 3D GR TR=35ms/TE=11.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00005.nii     1          164,212,158     3T 3D GR TR=35ms/TE=14.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00006.nii     1          164,212,158     3T 3D GR TR=35ms/TE=17.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00007.nii     1          164,212,158     3T 3D GR TR=35ms/TE=20.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PD_00008.nii     1          164,212,158     3T 3D GR TR=35ms/TE=23.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458
% x_c_PDphase.nii      8          164,212,158
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯





