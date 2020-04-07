function fig = pretty_plots(fig,sz_in,dpi,svf,fileID,fmt)
%% It saves the figure file at the specified location with correct format

%---------------------------------INPUT------------------------------------
% fig    - the figure to be worked upon
% sz_in  - vector of size 1x2, figure size in inches [width, height]
% dpi    - scalar, dots per inch of the saved figure (usually >= 300)
% svf    - save file to disk ('Y' is yes)
% fileID - string, complete file path with filename (except the file extension)
% fmt    - this string specifies the file extension like 'meta', 'epsc',
%          'png', 'tiff'

%--------------------------------OUTPUT------------------------------------
% None displayed
% fhandle - returns the figure handle

%% Actual code begins
narginchk(3,6);

% fig            = fig;
fig.Units      = 'Inches';
fig.Position   = [0,0,sz_in];
fig.PaperUnits = 'Inches';
fig.PaperSize  = sz_in;
set(fig,'color','w');
% keyboard
if nargin > 3
    if strcmp(svf, 'Y') == 1 || strcmp(svf, 'y') == 1
        if nargin < 6
            error('You wish to save the file to disk. You must eneter filepath (fileID) and extension (fmt)')
        else
            res_str = ['-r',num2str(dpi)];
            format  = ['-d',fmt];
            
            % set(fig,'paperunits','inches','paperposition',[0 0 sz_in]);
            print(fileID,format,res_str);
        end
    end
end

end