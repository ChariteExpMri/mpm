
if 0
    % ==============================================
    %%  get orientation from [tw2] relative to [T1_im1]
    % ===============================================
    
    px='F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9'
    % #g example
%     p.f1=fullfile(px,'t2.nii'); % SOURCE
%     p.f2=fullfile(px,'test_t1_first_001.nii');   % REFIMAGE
    
    p.f2=fullfile(px,'test_t1_first_001.nii'); % SOURCE
    p.f1=fullfile(px,'t2.nii');   % REFIMAGE
    
    p.info=''; % info
    p.wait=0;              % busy mode
    manuorient3points(p);  % execute function
    
    % resulting-->  1.5708 1.837e-16 1.5708
    % ==============================================
    %%
    % ===============================================
end
% ======================================================
% BATCH:        [xcoreg.m]
% #b descr:  #b coregister images using affine transformation, 
% ======================================================
z=[];
z.TASK='[100] noSPMregistration, only elastix';
z.targetImg1    = { 'test_t1_first_001.nii' };                                                              % % target image [t1], (static/reference image)                                                                               
z.sourceImg1    = {'t2.nii'};% { 'test_t1.nii' };                                                         % % source image [t2], (moved image)                                                                                          
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
z.warpParamfile={ 'f:\antx2\mritools\elastix\paramfiles\trafoeuler5_MutualInfo.txt' };
z.warpPrefix='c_';
z.cleanup=[1];
z.preRotate=[1.5708 1.837e-16 1.5708];%[ 0 1.5708 -1.5708];%[1.5708 -6.1232e-17 1.5708];%
xcoreg(0,z);


% ==============================================
%%   
% ===============================================



