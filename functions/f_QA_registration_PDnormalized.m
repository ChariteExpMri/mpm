


% ==============================================
%%
% ===============================================
function f_QA_registration_PDnormalized(mdirs);
% clc

if exist('mdirs')==1 && ~isempty(mdirs)
    z.study =fileparts(fileparts(mdirs{1}));
else
    global an
        mdirs=antcb('getallsubjects');
    % mdirs=antcb('getsubjects');
    z.study    =fileparts(an.datpath);
end

% fi={ 'AVGT.nii'
%     'x_t2.nii'}

z.file1   ='PD_normalized.nii';
z.file2   ='AVGT.nii';
% z.dim     =[1:3];
z.dim     =[2];
z.nslices =8;
z.sb      =[1 nan];
z.outdir  ='checks';

z.linestyle=':';
z.linewidth=0.3;
z.colour   ='r';

z.saveresolution=600;
z.mdirs    =mdirs;
[~,z.studyname]=fileparts(z.study);

z.t={};
%% ===============================================
for i=1:length(mdirs)
    pdisp(i,1);
    z.pa=mdirs{i};
    z.i=i;
    [z]=makecontourplot(z);
end
disp(['DONE!']);

makeHTML(z);

function makeHTML(z)

%% ===============================================

sp='&nbsp';
htmlfile=fullfile(z.paout,[z.paout_sub '.html']);
aa={'<html>'
    [ '<font color=blue>' '<h3  style="margin-top:0;margin-bottom:0"> '  sp    z.studyname  '</h3>'  '<font color=black>' ]
    };

aa(end+1,:) ={'<pre><span class="inner-pre" style="margin-top:0;margin-bottom:0;font-family:consolas;font-size: 12px">'};
aa{end+1,1} =['path    : '  z.study      ];
aa{end+1,1} =['time    : '  datestr(now) ];
aa{end+1,1} =['bg-image: "'  z.file1 '"' ];
aa{end+1,1} =['fg-image: "'  z.file2 '"' ];
% aa{end+1,1} =['<br>'  ];
aa{end+1,1}=    '</span></pre>';

ae={'<br><br><br><br></html>'};

%<img src="/images/html5.gif" alt="HTML5 Icon" style="width:128px;height:128px;">
w={};
for i=1:size(z.t,1)
    imgs=z.t{i,2};
    wt={};
    wt{end+1,1}=[ '<font color=green>' '<h5 style="margin-top:0;margin-bottom:0"> ' num2str(i) ']'  sp    z.t{i}   '</h5>'  '<font color=black>' ] ;
    if length(imgs)==0
        wt{end+1,1}=[ '<font color=red>' '<h5 style="margin-top:0;margin-bottom:0"> ' '....file not found!'   '</h5>'  '<font color=black>' ] ;
    end
    for j=1:length(imgs)
        
        
        
        v=[ './' z.paout_sub '/' imgs{j}  ];
        %wt{end+1,1}=['<img src="' v '" alt="w" style="height:200px;">'];
        wt{end+1,1}=['<img src="' v '" alt="not founf" style="width:1300px;">'];
        wt{end+1,1}=['<br>'];
    end
    w=[w; wt];
end

% table
mdirsFP=stradd(z.t(:,1),[z.study filesep 'dat' filesep],1);
t1=[num2cell(1:length(z.t(:,1)))' z.t(:,1) mdirsFP];
ht1={'idx' 'animal' 'path'};
t1w=plog([],[ht1;t1],0,'animals','plotlines=0;al=1');
% ===============================================

g          ={'<pre><span class="inner-pre" style="font-family:consolas;font-size: 10px">'};
g{end+1,1} =   ['<b><mark>' t1w{1,:} '</b>'];
g          =[g;    t1w(2:end,:)  ];
g{end+1,1}=    '</span></pre>';
% ]
% ===============================================


x=[aa; w; g ;ae];
pwrite2file(htmlfile, x);
showinfo2(['html'],htmlfile);

%  keyboard

%% ===============================================

function [z]=makecontourplot(z)

%% ===============================================
pa=z.pa;
[~,animal]=fileparts(pa);
f1=fullfile(pa,z.file1);
f2=fullfile(pa,z.file2);
[paout, outdir]=fileparts(z.outdir);
if isempty(paout); paout=z.study; end
paout=fullfile(paout,outdir);
paout_sub=regexprep(['QA_REG_contour', z.file1  '--' z.file2  ],'.nii','');
paout_subFP=fullfile(paout, paout_sub);
if exist(paout)~=7; mkdir(paout); end
if exist(paout_subFP)~=7; mkdir(paout_subFP); end

if exist(f1)==2 && exist(f2)==2
    
    
    
    
    %% ===============================================
    dims=z.dim;
    t=[];
    imgnames={};
    for i=1:length(dims)
        dim    =dims(i);
        nslices=z.nslices;
        
        h=spm_vol(f1);
        slicenr=round(linspace(1,h.dim(dim),nslices+2));
        slicenr([1 end])=[];
        
        [d ds]=getslices(f1     ,dim,[slicenr],[],0 );
        [o os]=getslices({f1 f2},dim,[slicenr],[],0 );
        
        d=flipdim(d,1);
        o=flipdim(o,1);
        d1=montageout(permute(d,[1 2 4 3]),'Size',z.sb);
        o1=montageout(permute(o,[1 2 4 3]),'Size',z.sb);
        
        d1=imadjust(mat2gray(d1))*255;
        
        hf=figure('visible','off');
        imagesc(d1); colormap(gray) ;hold on;
        contour(o1,3,'color',z.colour,'linewidth',z.linewidth,...
            'linestyle',z.linestyle)
        axis image
        axis off
        %% ===============================================
        imgtag=regexprep([ z.file1  '--' z.file2 '_dim', num2str(dim) ],'.nii',''  );
        fname=[animal '_' imgtag '.png'];
        imgnames{i}=fname;
        filename=fullfile(paout_subFP, fname);
        
        
        
        if 1
            hf=gcf;
            % print(hf,Fo1,'-dpng',['-r'  num2str(z.saveresolution) ]);
            % showinfo2(['img'],Fo1);
            
            z.bgtransp=1;
            z.crop=1;
            
            if z.bgtransp==1; set(gcf,'InvertHardcopy','on' );
            else ;            set(gcf,'InvertHardcopy','off');
            end
            % set(gcf,'color',[1 0 1]);
            % set(findobj(gcf,'type','axes'),'color','none');
            
            % set(hf,'InvertHardcopy','off');
            % print(hf,filename,'-dpng',['-r'  num2str(p.saveres) ], '-painters');
            print(hf,filename,'-dpng',['-r'  num2str(z.saveresolution) ]);
            close(hf);
            
            if z.bgtransp==1 || z.crop==1;
                [im hv]=imread(filename);
                if z.crop==1;
                    v=mean(double(im),3);
                    v=v==v(1,1);
                    v1=mean(v,1);  mima1=find(v1~=1);
                    v2=mean(v,2);  mima2=find(v2~=1);
                    do=[mima2(1)-1 mima2(end)+1];
                    ri=[mima1(1)-1 mima1(end)+1];
                    if do(1)<=0; do(1)=1; end; if do(2)>size(im,1); do(2)=size(im,1); end
                    if ri(1)<=0; ri(1)=1; end; if ri(2)>size(im,2); ri(2)=size(im,2); end
                    im=im(do(1):do(2),ri(1):ri(2),:);
                end
                if z.bgtransp==1
                    imwrite(im,filename,'png','transparency',[1 1  1],'xresolution',z.saveresolution,'yresolution',z.saveresolution);
                    if 0
                        imd=double(im);
                        pix=squeeze(imd(1,1,:));
                        m(:,:,1)=imd(:,:,1)==pix(1);
                        m(:,:,2)=imd(:,:,2)==pix(2);
                        m(:,:,3)=imd(:,:,3)==pix(3);
                        m2=sum(m,3)~=3;
                        imwrite(im,filename,'png','alpha',double(m2));
                    end
                    %         showinfo2(['saved png(resolution:' num2str(p.saveres)  ')'],filename);
                    
                    %
                else
                    imwrite(im,filename,'png');
                end
            end
            % showinfo2(['img'],filename);
        end
        
    end
else
    
    imgnames=[];
    
    
end


t={animal imgnames   };
z.t=[z.t; t];
z.paout       =paout;
z.paout_sub   =paout_sub;
z.paout_subFP =paout_subFP;


%% ===============================================

% cf
% z.contourlines=10;
%
% d1=d(:,:,5);
% o1=o(:,:,5);
% fg,imagesc(d1); hold on; contour(o1,10,'color','r')
%
% %  hold on;contour(v.o2,size(v.numcols,1));
% %  c=contourc(double(x),1);
%
% c=contourc(o1,z.contourlines)
% c2=contourdata(c);
% cc=round(co);



