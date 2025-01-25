

% ==============================================
%%  get anatomical labels
% ===============================================
cf;clear
antcb('selectdirs','all'); drawnow;

% files and output-tags
files=...
{'PD_normalized.nii'                  'PD' 
 'x_PD_00001_RFSC_A.nii'              'A'     
 'x_PD_00001_RFSC_MTsat.nii'          'MTsat'         
 'x_PD_00001_RFSC_R1.nii'             'R1'      
 'x_PD_00001_RFSC_R2s_OLS.nii'        'R2s_OLS'           
};

%masks to use
masksTB={...
    ''
     'H:\Daten-2\Imaging\AG_Paul_Brandt\analysis_2025\make_mask_MWF2\code\MWF2mask.nii'
     };




 for i=1:size(files,1)
     infile=files{i,1};
     
     
     for j=1:length(masksTB)
         mask=masksTB{j};
         [~, masktag]=fileparts(mask);%masktag=regexprep(masktag, 'mask','');
         if ~isempty(masktag); masktag=['__' masktag]; end
         outfile=[ 'AL_' files{i,2}   masktag ];
         cprintf('*[0 0 1]',['infile:'  infile  '\n']);
         cprintf('*[1 0 1]',['outfile:' outfile  '\n']);
         
         z=[];
         z.files        =infile;% { 'PD_normalized.nii' };                                                                    % % files used for calculation
         z.masks        = mask;     % % <optional> corresponding maskfiles (order is irrelevant)or mask from templates folder
         z.atlasOS      = '';                                                                                         % % The atlas in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
         z.hemimaskOS   = '';                                                                                         % % The hemispher mask in "other space". IMPORTANT ONLY IF "SPACE"-PARAMER IS SET TO "other">
         z.atlas        = 'ANO.nii';                                                                                  % % select atlas here (default: ANO.nii), atlas has to be the standard space atlas
         z.space        = 'standard';                                                                                 % % use images from "standard","native" or "other" space
         z.hemisphere   = 'both';                                                                                     % % hemisphere used: "left","right","both" (united)  or "seperate" (left and right separated)
         z.threshold    = '';                                                                                         % % lower intensity threshold value (values >=threshold will be excluded); leave field empty when using a mask
         z.fileNameOut  = outfile;%'PD_test';                                                                         % % <optional> specific name of the output-file. EMPTY FIELD: use timestamp+paramter for file name
         z.format       = '.xlsx';                                                                                    % % select output-format: default: ".xlsx"; other formats: ".mat" ".csv" ".csv|tab" "csv|space"  "csv|bar"  ".txt|tab" ".txt|space",".txt|bar"                                                                                       % % max of values (intensities) within anatomical region
         xgetlabels4(0,z);
     end
 end


