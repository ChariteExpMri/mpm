
% .
% 
% #yk mpm
% 
% #b &#8658; Respository: <a href= "https://github.com/ChariteExpMri/mpm">https://github.com/ChariteExpMri/mpm</a>
% 
% 
% 
%======= CHANGES ================================
% #ba 01 Sep 2023 (12:53:02)
% [+] pushed [mpm] to github
% update-button/version-update added
% #ba 01 Sep 2023 (15:07:10)
% #k [mpmlink.m] #n added: set path of mpm-tbx
% #ba 05 Sep 2023 (00:15:57)
% added tutorial "tutorial_mpm.docx"
% % #ba 05 Sep 2023 (16:18:06)
% tested on win10 server
% 
% 
% 

%----- EOF
% make MPMVER.md for GIT: mpmver('makempmver')


function mpmver(varargin)
r=strsplit(help('mpmver'),char(10))';
ichanges=regexpi2(r,'#*20\d{2}.*(\d{2}:\d{2}:\d{2})' );
lastchange=r{ichanges(end)};
lastchange=regexprep(lastchange,{'#\w+ ', ').*'},{'',')'});
r=[r(1:3); {[' last modification: ' lastchange ]}  ;  r(4:end)];

if nargin==1
    if strcmp(varargin{1},'makempmver')
        makempmver(r);
        return
    elseif strcmp(varargin{1},'new')
           clipboard('copy', [    ['% #ba '   datestr(now,'dd mmm yyyy (HH:MM:SS)') repmat(' ',1,0) ]           ]); 
           a=preadfile(which('mpmver.m'))
           matlab.desktop.editor.openAndGoToLine(which('mpmver.m'), min(regexpi2(a.all,'EOF')));
           return
    end
end

uhelp(r,0, 'cursor' ,'end');
set(gcf,'NumberTitle','off', 'name', 'mpm - VERSION');
if 0
    clipboard('copy', [    ['% #ba '   datestr(now,'dd mmm yyyy (HH:MM:SS)') repmat(' ',1,0) ]           ]);
    clipboard('copy', [    ['% #T '   datestr(now,'dd mmm yyyy (HH:MM:SS)') '' ]           ]);
end


return

function makempmver(r)
% this makes a human readable mpmver.md


i1=min(regexpi2(r,'CHANGES'));
head=r(1:i1);

s1=r(i1+1:end); % changes
lastline=max(regexpi2(s1,'\w'));
s1=[s1(1:lastline); {' '}];

%resort time: new-->old
it=find(~cellfun(@isempty,regexpi(s1,['#\w+.*(\d\d:\d\d:\d\d)'])));
it(end+1)=size(s1,1);

% % https://stackoverflow.com/questions/11509830/how-to-add-color-to-githubs-readme-md-file
% tb(1,:)={ '#yk'    '![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) '  'red' } ;
% tb(2,:)={ '#ok'    '![#c5f015](https://via.placeholder.com/15/c5f015/000000?text=+) '  'green' } ;
% tb(3,:)={ '#ra'    '![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) '  'blue' } ;
% tb(4,:)={ '#bw'    '![#FF00FF](https://via.placeholder.com/15/FF00FF/000000?text=+) '  'margenta' } ;
% tb(5,:)={ '#gw -->' '&#8618;'  'green arrow' } ;
% tb(6,:)={ '#ba'    '![#1589F0](https://via.placeholder.com/15/1589F0/000000?text=+) '  'blue' } ;
% tb(7,:)={ '#k '     ' '  'remove tag' } ;
% tb(8,:)={ ' #n '    ' '  'remove tag' } ;
% tb(9,:)={ ' #b '    ' '  'remove tag' } ;
%% ============[new dots/symbols]===================================
tb={};
tb(end+1,:)={ '#ba'    '&#x1F535; ' '&#x1F535; LARGE BLUE CIRCLE --new date dot '   } ;
tb(end+1,:)={ '#bw'    '&#x1F4D7; ' '&#x1F4D7; GREEN BOOK -->new tutorial '   } ;
tb(end+1,:)={ '#ra'    '&#x1F535; ' '&#x1F535; LARGE BLUE CIRCLE --new date dot (used in older dates in antver) '   } ;
tb(end+1,:)={ '#ok'    '&#x1F34E; ' '&#x1F34E; green apple   new antx-version' } ;
tb(end+1,:)={ '#T'     '&#x1F4D9; ' '&#x1F4D9; :ORANGE BOOK, new   github pages' } ;

tb(end+1,:)={ '#yk'    '![#f03c15](https://via.placeholder.com/15/f03c15/000000?text=+) '  'red' } ;
tb(end+1,:)={ '#gw -->' '&#8618;'  'green arrow' } ;
tb(end+1,:)={ '#wm -->' '&#9829;'  'SCRIPTS' } ;
tb(end+1,:)={ '#k '     ' '  'remove tag' } ;
tb(end+1,:)={ ' #n '    ' '  'remove tag' } ;
tb(end+1,:)={ ' #b '    ' '  'remove tag' } ;


s2=[];
for i=length(it)-1:-1:1
    dv2=s1(it(i):it(i+1)-1);
    
    dv2=regexprep(dv2, {'\[','\]'},{'__[',']__' }); %bold inside brackets
    
    l1=dv2{1};
    idat=regexpi(l1,'\d\d \w\w\w');
    dat=l1(idat:end);
    col=l1(1:idat-1);
    
    dat2=[col ' <ins>**' dat '</ins>' ]; %underlined+bold
    dat2=regexprep(dat2,')',')**');
    
    
    dv2=[ dat2;  dv2(2:end) ];
    %    dv2=[{ro};{ro2}; dv2];
    
    
    for j=1:size(tb,1)
        dv2=cellfun(@(a) {[regexprep(a,tb{j,1},tb{j,2})]} ,dv2 ) ; %green icon for #ok
    end
    
    
    dv2=cellfun(@(a) {[a '  ']} ,dv2 ); % add two spaces for break <br>
%     dv2{end}(end-1:end)=[]; %remove last two of list to avoid break ..would hapen anyway
%   dv2(end+1,1)={'<!---->'}; %force end of list
%     el=dv2{end};
    if ~isempty(regexpi(dv2 ,'^\s*-\s|^\s*\(\d+)\s|^\s*\d+)\s'))
        dv2(end+1,1)={'<!---->'}; %force end of list
    end
    s2=[s2; dv2];
end


head0={'## **mpm Modifications**'};
head1=head(regexpi2(head,'mpm')+1:end);
head1(regexpi2(head1,' CHANGES'))=[];%remove  '=== CHANGES ==' line
head1=[head1; '------------------' ];%'**CHANGES**'
head1=cellfun(@(a) {[regexprep(a,'last modification:',[tb{1,2} 'last modification:']) ]} ,head1 ) ; %red icon for last modific
head1=cellfun(@(a) {[a '  ']} ,head1 ); % add two spaces for break <br>

w=[head0; head1; s2];

% tes1='```js ...
%   import { Component } from '@angular/core';
%   import { MovieService } from './services/movie.service';
% 
%   @Component({
%     selector: 'app-root',
%     templateUrl: './app.component.html',
%     styleUrls: ['./app.component.css'],
%     providers: [ MovieService ]
%   })
%   export class AppComponent {
%     title = 'app works!';
%   }
% ```'

% w=[ '<font size="+5">' ;w; '</font>'];
w=regexprep(w,' #b ','');

fileout=fullfile(fileparts(which('mpmver.m')),'mpmver.md');
pwrite2file(fileout,w);






