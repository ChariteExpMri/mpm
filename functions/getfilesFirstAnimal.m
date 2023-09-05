

function getfilesFirstAnimal
%% ===============================================
pas=antcb('getsubjects');
pa=pas{1};
% pa='F:\data7\MPM_agBrandt\dat\20220725AB_MPM_18-9';
[~, animal]=fileparts(pa);
cprintf('*[0 0 1]',[ ['FILES OF ANIMAL: [' animal ']']  '\n'] );
k=dir(fullfile(pa,'*.nii'));
names={k(:).name}';
for i=1:length(names)
    disp(names{i});
end