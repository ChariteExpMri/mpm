

% register turborare to T1/MT/PD
function f_registerTurborare(mdirs)
% ==============================================
%%   example without ANTX-tbx
% ===============================================
if 0
   f_registerTurborare({'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'})
   
   mdirs={
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_12-4'
       'F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9'
       };
   f_registerTurborare(mdirs)
   
end
%% =============  get PARAMETER ==================================
f_getconfig();
global mpm
a2=mpm.niftis.a2;
%% =========[animal dirs]======================================
mdirsExtern=0;
if exist('mdirs')==1
    mdirs=cellstr(mdirs);
    try
    antcb('selectdirs',mdirs); drawnow;
    end
    mdirsExtern=1;
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



%% ==============[get variables ]===================
t         = mpm.niftis.f; %niftitable
preorient = mpm.t2w_preorient;
%% ===============================================


mov='t2w.nii';%g.files{strcmp(g.files(:,1),'t2w'),2};

if      ~isempty(find(strcmp(t(:,1),'T1')==1))
    fix='XXXX1.nii' ;
elseif  ~isempty(find(strcmp(t(:,1),'MT')==1))
    fix='MT.nii' ;
elseif  ~isempty(find(strcmp(t(:,1),'PD')==1))
    fix='PD.nii' ;
end

cprintf('*[0 0 1]',[ ['register turborare: "' mov '"  to "' fix '"' ] '\n'] );

z=[];
z.TASK='[100] noSPMregistration, only elastix';
% z.targetImg1    ={'04_2_MPM_3D_0p15_t1_exvivo_1.nii'};% { 'test_t1_first_001.nii' };                                                              % % target image [t1], (static/reference image)                                                                               
% z.sourceImg1    = {'t2.nii'};% { 'test_t1.nii' };                                                         % % source image [t2], (moved image)                                                                                          
z.targetImg1    ={fix};%{'04_2_MPM_3D_0p15_t1_exvivo_1.nii'};% { 'test_t1_first_001.nii' };                                                              % % target image [t1], (static/reference image)                                                                               
z.sourceImg1    ={mov};% {'t2.nii'};% { 'test_t1.nii' };  

z.sourceImgNum1=[1];
z.applyImg1={ '' };
z.cost_fun='nmi';
z.sep=[4  2  1  0.5  0.1  0.05];
z.tol=[0.01  0.01  0.01  0.001  0.001  0.001];
z.fwhm=[7  7];
z.centerering=[0];
z.reslicing=[0];
z.interpOrder='auto';
z.prefix='r';
z.warping=[1];
z.warpParamfile={which('trafoeuler5_MutualInfo.txt') };
z.warpPrefix='c_';
z.cleanup=[1];
% z.preRotate=[1.5708 1.837e-16 1.5708];%[ 0 1.5708 -1.5708];%[1.5708 -6.1232e-17 1.5708];%
z.preRotate=  preorient;%g.t2w_preorient;

if mdirsExtern==0;
    xcoreg(0,z);
else
    xcoreg(0,z,mdirs);
end
    

%% =========== rename registered t2w to t2.nii ====================================

if mdirsExtern==0;
    xrename(0,['c_' mov],'t2.nii',':');
else
    xrename(0,['c_' mov],'t2.nii',':', 'mdirs', mdirs );
end



