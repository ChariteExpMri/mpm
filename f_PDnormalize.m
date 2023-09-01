
%normalize image
function f_PDnormalize(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_PDnormalize({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
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
cprintf('*[0 0 1]',[ 'PD-normalize volume'  '\n'] );
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
[fis] = spm_select('FPList',pares,  ['^x_PD' '.*' '_A.nii$' ]);
if isempty(fis); return; end
fis=cellstr(fis);

if length(fis)>1; 
    keyboard; 
end

f1=fis{1};
disp([ '[normalize][' num2str(c.count)  ']: ' f1  ]);

% [ha Y]=rgetnii(f1);
ha=spm_vol(f1);
Y =spm_read_vols(ha);

% ==============================================
%%   get reference-Mask
% ===============================================
fm=mpm.PD_normalizeMask;
hc=spm_vol(fm);
c =spm_read_vols(hc);

imask=find(c>0);
refvec=Y(imask);
refval=feval(mpm.PD_normalizeFunction,refvec);
Y2=Y/refval*100;

refpostval=feval(mpm.PD_normalizeFunction,Y2(imask));


% me=mean(csfsig);
% Y2=Y/me*100;


% 
%  
% %% ========= [ventricle ]======================================
% iventricle=find(g.ventricle==1);
% csfsig=Y(iventricle);
%  me=mean(csfsig);
% % me=prctile(csfsig,30);
% Y2=Y/me*100;
% % ===========[graymatter]====================================
% if 0
%     fcsf=fullfile(g.patemp,'_b3csf.nii');
%     [hc c]=rgetnii(fcsf);
%     
%     cm=c>0.8;
%     me=mean(Y(cm==1));
%     Y2=Y/me*100;
% end
% % ===========[specific mask]=====================
% fm='F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4\mask_water.nii'
% [hc c]=rgetnii(fm);
% imask=find(c==1);
% csfsig=Y(imask);
% me=mean(csfsig);
% Y2=Y/me*100;

%===============================================

% ==============================================
%%   write NIFTI
% ===============================================
outname=mpm.PD_normalizeOutputName;
if isempty(outname)
    outname='PD_normalized.nii';
end
[px outname ext]=fileparts(outname);
outname=[outname ext];

% fname='PD_CSF_test.nii';
f2=fullfile(pa,outname);
if exist(f2); delete(f2); end
hb=ha;
hb.fname=f2;
hb.dt=[64 0];
hb=spm_create_vol(hb);
hb=spm_write_vol(hb, Y2);

% rsavenii(f2,ha,Y2);
global an
if isempty(an)
    if exist('showinfo2.m')==2
        showinfo2(['  normed PD-image:' ],f2);
    else
        disp(['   created normalized image: "' outname '" for animal [' pa ']']);
    end
    return
end


%% ===============================================
%% if ANTx-study exists 
%% ===============================================

%% ====[show hyperlinks]===========================================
if ~isempty(an)
    patemplate=fullfile(fileparts(an.datpath),'templates');
    fb=fullfile(patemplate,'AVGT.nii');
    showinfo2(['  normalized image:' ],fb,f2,0);
    showinfo2(['  normalized image-reversed:' ],f2,fb,0);  
end
%% ======[display mean values]============================
comps={'_b1grey.nii' '_b2white.nii' '_b3csf.nii'};
thresh=0.3;
for i=1:length(comps)
   fc=fullfile(patemplate,comps{i});
   [hb b]=rgetnii(fc);
   r=Y2(b>thresh);
   mc=mean(r);
%    disp([ 'mean Value: '  comps{i} ':'  num2str(mc) ]);
   fprintf(['  mean:'  '%1.1f\t for [%s] above threshold (%1.1f) \n'],mc,comps{i} ,thresh );%mean(above thresh=%1.1f) [%s]:
   
%    length(r)
end
%    fprintf('mean [%s]:  \t%2.2f \n','ventricle',(mean(Y2(iventricle))));
disp(['  reference value after normalization:'  num2str((refpostval)) ' ..as defined from mpm.PD_normalizeFunction (@' func2str(mpm.PD_normalizeFunction) ')' ]);



% ==============================================
%%   
% ===============================================

return


% ==============================================
%%   old
% ===============================================

% 
% patemp=fullfile(fileparts(fileparts(pas{1})),'templates');
% ano=fullfile(patemp,'ANO.nii');
% anox=regexprep(ano,'.nii','.xlsx');
% 
% % f1=fullfile(pa,'ANO.nii');
% [hat at]=rgetnii(ano);
% 
% % f2=fullfile(pa,'ANO.xlsx');
% [~,~,a0]=xlsread(anox);
% [a0]=xlsprunesheet(a0);
% ix=regexpi2(a0(:,1),'lateral ventricle');
% 
% id=(a0{ix,4});
% ch=str2num(a0{ix,5});
% g.ventricle=double(at==id);
% g.patemp=patemp;


 %% ===============================================
    
% pa='F:\data7\MPM_mouse\MPM_mouse\mouse_template'
% f1=fullfile(pa,'ANO.nii');
% [hat at]=rgetnii(f1);
% 
% f2=fullfile(pa,'ANO.xlsx');
% [~,~,a0]=xlsread(f2);
% [a0]=xlsprunesheet(a0);
% ix=regexpi2(a0(:,1),'lateral ventricle')
% 
% id=(a0{ix,4})
% ch=str2num(a0{ix,5})
% 
% m=double(at==id);




csfsig=Y(m==1);
% thresh=prctile(csfsig,95);
% thresh=prctile(csfsig,50);
% me=mean(csfsig(csfsig>thresh));
me=mean(csfsig)
Y2=Y/me*100;
fname='PD_CSF_test.nii';
rsavenii(fname,hat,Y2)
showinfo2('..RESULTS',fname);
