

% ==============================================
%%   create ventricle mask
% ===============================================
clear


pa='F:\data7\MPM_agBrandt\templates'
f1=fullfile(pa,'ANO.nii');
% [hat at]=rgetnii(f1);

hat=spm_vol(f1);
[at ]=(spm_read_vols(hat));


f2=fullfile(pa,'ANO.xlsx');
[~,~,a0]=xlsread(f2);
% [a0]=xlsprunesheet(a0);
% ix=regexpi2(a0(:,1),'lateral ventricle')
ix=find(strcmp(a0(:,1),'lateral ventricle'));

id=(a0{ix,4})
% ch=str2num(a0{ix,5})
m=double(at==id);


hb=hat;
hb.fname='F:\data7\MPM_agBrandt\mpm_functions\resources\mask_ventricle.nii'
hb=spm_create_vol(hb)
hb.dt=[16 0];
spm_write_vol(hb,m)