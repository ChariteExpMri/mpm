


% ==============================================
%%  MPM: import bruker data
% ===============================================

global an
studydir=fileparts(an.datpath);
w=xbruker2nifti(fullfile(studydir,'raw'),0,[],[],'gui',0,'show',1); 


%% ===display filtered ============================================
% w2=xbruker2nifti(w,0,[],[],'gui',0,'show',1,'flt',{'pro','03_1_T2_TurboRARE|04_1_MPM_3D_0p15_pd_exvivo|04_2_MPM_3D_0p15_t1_exvivo|04_3_MPM_3D_0p15_mt_exvivo' } );
w2=xbruker2nifti(w,0,[],[],'gui',0,'show',1,'flt',{'pro',...
    'TurboRARE|pd|t1|mt' } );
w2.showtable2(w2) ;%show table

%% ===import filtered ============================================

w2=xbruker2nifti(w,0,[],[],'gui',0,'show',0,'flt',{'pro',...
    'TurboRARE|pd|t1|mt' } );


%% ===============================================
dispfiles




