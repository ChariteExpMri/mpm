
%% link mpm-TOOLBOX
% mpmlink or mpmlink(1) to setpath of mpm-TBX
% mpmlink(0) to remove path of mpm-TBX

function mpmlink(arg)

if exist('arg')~=1
    arg=1;
end
paprev=pwd;
if arg==1 %addPath
    pa=pwd;
   
    
    mpm_path=fileparts(which('mpm.m'));
    ix_mpm_path=strfind(path,mpm_path);
    if isempty(ix_mpm_path);     addpath((mpm_path));  end
    
    k=dir(mpm_path);
    isdirs=find([k.isdir]==1);
    subdirs={k(isdirs).name};
    subdirs=subdirs(cellfun(@isempty,regexpi(subdirs,'^.$|^..$|^.git$|^resources$')));
    % subdirs={'misc'}; %add subdirs
    for i=1:length(subdirs)
        this_subdir=fullfile(mpm_path,subdirs{i});
        if isempty(strfind(path,this_subdir))
            addpath(genpath(this_subdir));
        end
    end
      
    cd(pa)
    disp('..mpm - paths set (type "mpmlink(0) to remove paths")');
    showlastpath;
    
elseif arg==0  %remove path
    try
        warning off
        dirx=((fileparts(which('mpm.m'))));
        rmpath(genpath(dirx));
        disp('..[mpm] removed from matlab path ');
        %cd(dirx);
    end
end


%% gest last path

function showlastpath
pwnow=pwd;

try
    a=preadfile2(fullfile(prefdir,'matlab.settings'));
    
    i0=regexpi2(a,'<settings name="currentfolder">');
    i1=regexpi2(a,' <key name="History">');
    i2=regexpi2(a,' </key>');
    i2=i2(min(find(i1<i2)));
    ip=regexpi2(a,'<value><![CDATA[');
    
    ps=find(ip>i1 & ip<i2);
    
    pw=a(ip(ps));
    pw=regexprep(pw,{'.*[CDATA[',']]></value>'}, '');
    pw(regexpi2(pw, 'antx2'))=[];
    pwlast=pw{1};
    
    disp(['<a href="matlab: cd(''' pwlast ''');">' ['Go Back To:'  ] '</a>' ' ' pwlast ]);
    %disp(['<a href="matlab: ant;">' ['open mpm-GUI'  ] '</a>' ' '  ]);
    disp(['<a href="matlab: mpm;">' ['open mpm-GUI'  ] '</a>' ]);
end





