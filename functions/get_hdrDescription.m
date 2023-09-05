



% get_hdrDescription('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01')
% get_hdrDescription('F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01','^x_')
% 
function get_hdrDescription(px,flt)

%% ===============================================

if exist('flt')~=1
   flt='.*.nii' ;
end
% px='F:\data7\MPM_mouse\MPM_mouse\20190122GC_MPM_01'
% [fis] = spm_select('List',px,  ['^x_.*' '.nii' ]   );

[fis] = spm_select('List',px,  flt  );
fis=cellstr(fis);

tb={};
for i=1:length(fis)
    try
        hb=spm_vol(fullfile(px,fis{i}));
        name =fis{i};
        descr=hb(1).descrip;
        if isempty(descr);
            descr='none';
        end
        tb(end+1,:)=  {name descr};
    end
end
%% ===============================================

uhelp( plog([],[  tb] ),1);


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




