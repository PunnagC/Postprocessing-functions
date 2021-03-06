function [list,nlist] = get_legit_files(datapath,file)
% just creates a list of required files
% discards files like 'desktop.ini' and other crap in the folder by default
%-----------------------------INPUT----------------------------------------
% datapath - folder path string
% file     - structure containing two variables
%            file.remove - file name containing this string will be ignored
%            file.keep   - file name containing this string will be considered
%----------------------------OUTUT-----------------------------------------
% list  - cell string array of the file names filtered using 'file'
% nlist - length of the 'list'
%
% Example: file.remove = '.txt';
%          file.keep = 'p_1';
%          this will ignore all filenames that have '.txt' and consider
%          files that include the string 'p_1'

flag = 0;     %list all files
if nargin > 1 %selective files only
   flag = 1;
end
    
listing = dir(datapath); 
list    = {listing(1:end).name}';
nlist   = size(list,1);

%% Removing .ini, . and .. files
for i = 1 : nlist
%     keyboard
    if isempty(strfind(list{i},'.ini')) == 0  || isempty(strfind(list{i},'..')) == 0 %selecting files with '.txt' in it
        list{i} = [];
    end
    if flag == 1 %selective file removal is ON
        if isempty(strfind(list{i},file.remove)) == 0
            list{i} = [];
        end
    end
        
end
list(cellfun('isempty',list)) = []; %removing the empty cells

nlist = size(list,1);
     
%% Keeping files listed in 'file.keep'
for j = 1 : nlist
    if flag == 1
%         keyboard
        if isempty(strfind(list{j},file.keep)) == 1 %selecting files with '.txt' in it
            idx     = j;
            list{j} = [];                        %list with .txt are set to [] or empty cells
        end
    end
end
list(cellfun('isempty',list)) = []; %removing the empty cells

nlist = size(list,1);

end