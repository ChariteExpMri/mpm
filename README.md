
# MPM
wrapper functions to run hMRI-toolbox on rodent data
For hMRI-toolbox see 
- https://www.cbs.mpg.de/departments/neurophysics/software/hmri-toolbox
- https://github.com/hMRI-group/hMRI-toolbox

## UPDATES ##
&#x1F535; Inspect [**last changes/updates**](mpmver.md).<br>

## Installation ##
### Installation via GITHUB using GIT
ADVANTAGE: updates can be made via toolbox         
- download & install GIT client --> https://git-scm.com/downloads
    just follow instructions and keep the default properties
- browse to LINK: https://github.com/ChariteExpMri/mpm
- select "install_mpm.m" and click [RAW]-button 
  or go to here: https://raw.githubusercontent.com/ChariteExpMri/mpm/master/install_mpm.m
- select "save as" (cmd+s or ctrl+s) and save file as "install_mpm.m"
- copy "install_mpm.m" to the location where mpm should be installed.
  ..please don't create a folder with name "mpm", this folder will be created later on
## OPEN GUI ##
- set MATLAB's current working dir to the location of "mpm" 
- type 'mpm'

## MANDATORY PACKAGES ##
<ins>hMRI-toolbox</ins>
The hMRI-toolbox is needed.  Here, hMRI-toolbox-0.2.4 was tesed: 
https://github.com/hMRI-group/hMRI-toolbox/releases

<ins>ANTx2</ins>
For Preprocessing ANTx2 is mandatory (see tutorial)
https://github.com/ChariteExpMri/antx2

## Tutorial ##
For a tutorial see: 
https://raw.githubusercontent.com/ChariteExpMri/mpm/master/tutorial_mpm.docx






