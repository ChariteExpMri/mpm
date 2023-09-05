
%add HDR-description to final files in standardSpace
function f_addHDRdescrition(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_addHDRdescrition({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'});
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
cprintf('*[0 0 1]',[ 'add Header-description'  '\n'] );
for i=1:length(mdirs)
    c.count=i;
    proc(mdirs{i},mpm,c);
end
cprintf('*[0 0 1]',[ 'DONE! '  '\n'] );


% ==============================================
%%   
% ===============================================

function proc(pa,mpm,c)


%% ===============================================
ha =mpm.niftis.ha; %header
t  =mpm.niftis.f ;%files-table

t(strcmp(t(:,1),'t2w'),:)=[];
files=t(:,1);

ms='';  %get columns of table
iFA=find(strcmp(ha,'FA_deg'));
iTR=find(strcmp(ha,'TR_ms'));
iTE=find(strcmp(ha,'TE_ms'));
timex=datestr(now);
%% =========MAKE TABLE for files with HDR-CHANGES ======================================
t2={};
for i=1:length(files)
    [fis] = spm_select('List',pa,  ['^x_' files{i} '_\d+.nii' ]);
    fis=cellstr(fis);    
    for j=1:length(fis)
        switch files{i}
            case {'T1'    'MT'    'PD'}
                TEvec=t{i,iTE};
                TEvals=strsplit(TEvec,',');
                ms= [ ['3T 3D GR '] ['TR=' t{i,iTR}  'ms/'] [ 'TE=' TEvals{j} 'ms/']  ['FA=' t{i,iFA} 'deg/'] 'SO=MT ' timex];
                t2(end+1,:)={fis{j} ms};
        end
    end
end

%% ============[Message]===================================

cprintf('*[0 0 1]',[ 'changes in Header: '  '\n'] );
try
    hl=plog([],[  t2],0,'','plotlines=0' );
catch
    hl=cellfun(@(a,b){[ a  ': "' b '"']} ,t2(:,1),t2(:,2));
end
disp(char(hl));
%% ===========[change header]====================================


for i=1:size(t2,1)
    f1=fullfile(pa,t2{i,1});
    disp([ ' ..[add HDR-description][' num2str(c.count) '-'  num2str(i)  ']: ' f1 ]);
    h=spm_vol(f1);
    h.descrip=t2{i,2};
    spm_create_vol(h);
end

return


%% ===============================================






% ==============================================
%%   old
% ===============================================


%% =============  get PARAMETER ==================================

g      =f_getmrm_config();
[a2  c]=f_getparameters();
pas=antcb('getsubjects');
pa=pas{1};
%% ===============================================


t=c.f;
% files=t;%(:,1);
t(strcmp(t(:,1),'t2w'),:)=[];
files=t(:,1);;

% files=stradd(files0,'.nii',2);
% files=stradd(t,'x_',1);

ms='';
iFA=find(strcmp(c.ha,'FA_deg'));
iTR=find(strcmp(c.ha,'TR_ms'));
iTE=find(strcmp(c.ha,'TE_ms'));
timex=datestr(now);

t2={};
for i=1:length(files)
    
    [fis] = spm_select('List',pa,  ['^x_' files{i} '_\d+.nii' ]);
    fis=cellstr(fis);
    
%     disp('------');
%     disp(fis);
%     ms='';
    
    for j=1:length(fis)
        switch files{i}
            case {'T1'    'MT'    'PD'}
                TEvec=t{i,iTE};
                TEvals=strsplit(TEvec,',');
                ms= [ ['3T 3D GR '] ['TR=' t{i,iTR}  'ms/'] [ 'TE=' TEvals{j} 'ms/']  ['FA=' t{i,iFA} 'deg/'] 'SO=MT ' timex];
                t2(end+1,:)={fis{j} ms};
        end
    end
end

cprintf('*[0 0 1]',[ 'changes in Header: '  '\n'] );
hl=plog([],[  t2],0,'changes in Header' );
disp(char(hl));

% uhelp( plog([],[  t2],0,'changes in Header' ),1);
 %% ===============================================
 for i=1:size(t2,1)
     xrename(0,t2{i,1},t2{i,1},['descrip:' t2{i,2}]);
 end
 
 
 %% ===============================================
 
 
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
%          x_T1.nii                                                               none  
%    x_T1_00001.nii  3T 3D GR TR=35ms/TE=2.70ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00002.nii   3T 3D GR TR=35ms/TE=5.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00003.nii   3T 3D GR TR=35ms/TE=8.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00004.nii  3T 3D GR TR=35ms/TE=11.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00005.nii  3T 3D GR TR=35ms/TE=14.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00006.nii  3T 3D GR TR=35ms/TE=17.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00007.nii  3T 3D GR TR=35ms/TE=21.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%    x_T1_00008.nii  3T 3D GR TR=35ms/TE=23.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%     x_T1phase.nii                                                               none  
%        x_c1t2.nii                                                               none  
%        x_c2t2.nii                                                               none  
%        x_c3t2.nii                                                               none  
%        x_c_MT.nii                                                               none  
%  x_c_MT_00001.nii   3T 3D GR TR=35ms/TE=2.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_MT_00002.nii   3T 3D GR TR=35ms/TE=5.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_MT_00003.nii  3T 3D GR TR=35ms/TE=8.70ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_MT_00004.nii  3T 3D GR TR=35ms/TE=11.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_MT_00005.nii  3T 3D GR TR=35ms/TE=14.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_MT_00006.nii  3T 3D GR TR=35ms/TE=17.7ms/FA=28deg/SO=MT 28-Jul-2020 15:34:37.458 
%   x_c_MTphase.nii                                                               none  
%        x_c_PD.nii                                                               none  
%  x_c_PD_00001.nii   3T 3D GR TR=35ms/TE=2.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00002.nii   3T 3D GR TR=35ms/TE=5.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00003.nii   3T 3D GR TR=35ms/TE=8.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00004.nii  3T 3D GR TR=35ms/TE=11.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00005.nii  3T 3D GR TR=35ms/TE=14.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00006.nii  3T 3D GR TR=35ms/TE=17.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00007.nii  3T 3D GR TR=35ms/TE=20.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%  x_c_PD_00008.nii  3T 3D GR TR=35ms/TE=23.70ms/FA=5deg/SO=MT 28-Jul-2020 15:34:37.458 
%   x_c_PDphase.nii                                                               none  
%  x_c_c_hB0map.nii                                                               none  
%         x_mt2.nii                                                               none  
%          x_t2.nii                                                               none  
% ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

 

% 
% 
% 
% return
% for i=1:length(files)
%     f1= fullfile(pa,files{i});
%     hb=spm_vol(f1);
%     if length(hb)>1
%         cprintf('*[0 0 1]',[ ['splitting 4Dvol: '  files{i}] '\n'] );
%         xrename(0,files{i},files{i},':s');
%     end
% end

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