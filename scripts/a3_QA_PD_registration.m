
%% =====================================================                                                                                                                                                                                     
%% #g FUNCTION:    [xcheckreghtml.m]                                                                                                                                                                                                         
%%  #yk create HTML-files with overlay of images.                                                                                                                                                                                            
%% =====================================================

 antcb('selectdirs','all'); drawnow;
%antcb('selectdirs',1); drawnow;
z=[];                                                                                                                                                                                                                                        
z.backgroundImg = { 'PD_normalized.nii' };                                                                    % % [SELECT] Background/reference image (a single file)                                                                        
z.overlayImg    = { 'AVGT.nii' };                                                                             % % [SELECT] Image to overlay (multiple files possible)                                                                        
z.outputPath    = '';%H:\Daten-2\Imaging\AG_Paul_Brandt\analysis_2025\2024_Cuprizone_invivo_MPM_DTI\checks';     % % [SELECT] Outputpath: path to write HTMLfiles and image-folder. Best way: create a new folder "checks" in the study-folder )
z.outputstring  = 'PD';                                                                                       % % optional Output string added (suffix) to the HTML-filename and image-directory                                             
z.slices        = 'n6';                                                                                       % % SLICE-SELECTION: Use (1.) "n"+NUMBER: number of slices to plot or (2.) a single number, which plots every nth. image       
z.dim           = [2];                                                                                        % % Dimension to plot {1,2,3}: In standard-space this is: {1}transversal,{2}coronal,{3}sagital                                 
z.size          = [400];                                                                                      % % Image size in HTML file (in pixels)                                                                                        
z.grid          = [1];                                                                                        % % Show line grid on top of image {0,1}                                                                                       
z.gridspace     = [20];                                                                                       % % Space between grid lines (in pixels)                                                                                       
z.gridcolor     = [1  0  0];                                                                                  % % Grid color                                                                                                                 
z.cmapB         = '';                                                                                         % % <optional> specify BG-color; otherwise leave empty                                                                         
z.cmapF         = '';                                                                                         % % <optional> specify FG-color; otherwise leave empty                                                                         
z.showFusedIMG  = [0];                                                                                        % % <optional> show the fused image                                                                                            
z.sliceadjust   = [0];                                                                                        % % intensity adjust slices separately; [0]no; [1]yes                                                                          
xcheckreghtml(0,z); 