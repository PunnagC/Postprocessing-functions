function make_pub_fig(varargin)
%
% make_pub_fig
% make_pub_fig(xlims/xticks)
% make_pub_fig(xlims/xticks,ylims/yticks)
% make_pub_fig(h_fig,...)
% make_pub_fig(...,'bmp')
%
% Make a figure with suitable font sizes for publication (user configurable).
%
% [Inputs] (all optional)
% xlims/xticks = x-limits or x-tick locations, if this is a 2x1 vector it is intepreted as x-limits, otherwise x-ticks
% ylims/yticks = y-limits or y-tick locations, if this is a 2x1 vector it is intepreted as y-limits, otherwise y-ticks
% h_fig = handle to a figure (if this is not given, gcf is used)
% 'bmp' = if this string is given as the last input, the figure fonts are scaled for export to bmp file
%
% Written by Adam Wickenheiser
%

% parse inputs
if nargin > 0 && isscalar(varargin{1}) && isnumeric(varargin{1}) && ~ishandle(varargin{1})
	warning('Invalid figure handle passed to make_pub_fig.');
	return
end
if nargin == 0 % make_pub_fig
	h_fig = get(0,'CurrentFigure');
	xlims = []; xticks = []; ylims = []; yticks = [];
end
if nargin && strcmpi(varargin{end},'bmp')
	% figure is to be copied as a bitmap, so make everything larger
	fig_width = 6;   					% figure width (in.)
	fig_height = 6;	     		    % figure height (in.)
	title_font_size = 18;				% title font size
	axis_label_font_size = 18;			% axis label font size
	axis_tick_font_size = 18;			% axis tick labels font size
	axis_line_width = 2;				% axis/box line width
	line_width = 2;						% plot line width
	marker_size = 20;					% plot marker size
	legend_font_size = 14;				% legend font size
	nin = nargin - 1;
else
	fig_width = 10;		    		% figure width (in.)
	fig_height = 7;	         		% figure height (in.)
	title_font_size = 10;				% title font size
	axis_label_font_size = 29;			% axis label font size
	axis_tick_font_size = 29;			% axis tick labels font size
	axis_line_width = 1;				% axis/box line width
	line_width = 1;						% plot line width
	marker_size = 8;					% plot marker size
	legend_font_size = 17;				% legend font size
	nin = nargin;
end
if nin == 1
	if isscalar(varargin{1}) && ishandle(varargin{1}) % make_pub_fig(h_fig) or make_pub_fig(h_fig,'bmp')
		h_fig = varargin{1};
		xlims = []; xticks = []; ylims = []; yticks = [];
	elseif isnumeric(varargin{1}) % make_pub_fig(xlims/xticks) or make_pub_fig(xlims/xticks,'bmp')
		h_fig = get(0,'CurrentFigure');
		l = length(varargin{1});
		if l == 2
			xlims = varargin{1}; xticks = []; ylims = []; yticks = [];
		elseif l > 2
			xticks = varargin{1}; xlims = [xticks(1) xticks(end)]; ylims = []; yticks = [];
		else
			error('First argument to make_pub_fig must be a figure handle or an increasing array of length > 1');
		end
	else
		error('First argument to make_pub_fig must be a figure handle or an increasing array of length > 1');
	end
elseif nin == 2
	if isscalar(varargin{1}) && ishandle(varargin{1})
		h_fig = varargin{1};
		if isnumeric(varargin{2}) % make_pub_fig(h_fig,xlims/xticks) or make_pub_fig(h_fig,xlims/xticks,'bmp')
			l = length(varargin{2});
			if l == 2
				xlims = varargin{2}; xticks = []; ylims = []; yticks = [];
			elseif l > 2
				xticks = varargin{2}; xlims = [xticks(1) xticks(end)]; ylims = []; yticks = [];
			else
				error('Second argument to make_pub_fig must be an increasing array of length > 1');
			end
		else
			error('Second argument to make_pub_fig must be an increasing array of length > 1');
		end
	elseif isnumeric(varargin{1}) && isnumeric(varargin{2}) % make_pub_fig(xlims/xticks,ylims/yticks) or make_pub_fig(xlims/xticks,ylims/yticks,'bmp')
		h_fig = get(0,'CurrentFigure');
		l = length(varargin{1});
		if l == 2
			xlims = varargin{1}; xticks = [];
		elseif l > 2
			xticks = varargin{1}; xlims = [xticks(1) xticks(end)];
		else
			error('First argument to make_pub_fig must be a figure handle or an increasing array of length > 1');
		end
		l = length(varargin{2});
		if l == 2
			ylims = varargin{2}; yticks = [];
		elseif l > 2
			yticks = varargin{2}; ylims = [yticks(1) yticks(end)];
		else
			error('Second argument to make_pub_fig must be an increasing array of length > 1');
		end
	else
		error(['In two-argument call to make_pub_fig, first argument must be a figure handle or numeric array,'...
			   ' and second argument must be a numeric array']);
	end
elseif nin == 3 % make_pub_fig(h_fig,xlims/xticks,ylims/yticks) or make_pub_fig(h_fig,xlims/xticks,ylims/yticks,'bmp')
	if ~ishandle(varargin{1})  && length(varargin{1}) == 1, error('In three-argument call, first argument to make_pub_fig must be a figure handle'); end
	h_fig = varargin{1};
	if ~isnumeric(varargin{2}) || ~isnumeric(varargin{3}) || length(varargin{2}) < 2 || length(varargin{3}) < 2
		error('Second and third arguments to make_pub_fig must be increasing arrays of length > 1');
	end
	l = length(varargin{2});
	if l == 2
		xlims = varargin{2}; xticks = [];
	else
		xticks = varargin{2}; xlims = [xticks(1) xticks(end)];
	end
	l = length(varargin{3});
	if l == 2
		ylims = varargin{3}; yticks = [];
	else
		yticks = varargin{3}; ylims = [yticks(1) yticks(end)];
	end
end

% resize figure window and fonts
set(0,'Units','inches');
scrnsize = get(0,'ScreenSize');		% screen size (in.)
set(0,'Units','pixels');
set(h_fig,'Units','inches','Position',[.5*(scrnsize(3)-fig_width) .5*(scrnsize(4)-fig_height) fig_width fig_height]);
axes_handles = findobj(h_fig,'Type','axes','-not','Tag','legend');
% axes_handles = gca;		% need this line for subplot
for k = 1:length(axes_handles)
	h = get(axes_handles(k),'Title');
	if ~isempty(h)
		set(h,'FontSize',title_font_size);				% set title font size
	end
	h = get(axes_handles(k),'XLabel');
	if ~isempty(h)
		set(h,'FontSize',axis_label_font_size);			% set x label font size
	end
	h = get(axes_handles(k),'YLabel');
	if ~isempty(h)
		set(h,'FontSize',axis_label_font_size);			% set y label font size
	end
	set(axes_handles(k),'XMinorTick','on','YMinorTick','on','Box','on','FontSize',axis_tick_font_size,'LineWidth',axis_line_width);	% set tick size and axis/box width
	h = findobj(axes_handles(k),'Type','line');
	if ~isempty(h)
		set(h,'LineWidth',line_width,'MarkerSize',marker_size);
	end
	if ~isempty(xticks)
		set(axes_handles(k),'XLimMode','manual','XLim',xlims,'XTick',xticks);
	elseif ~isempty(xlims)
		set(axes_handles(k),'XLimMode','manual','XLim',xlims);
	end
	if ~isempty(yticks)
		set(axes_handles(k),'YLimMode','manual','YLim',ylims,'YTick',yticks);
	elseif ~isempty(ylims)
		set(axes_handles(k),'YLimMode','manual','YLim',ylims);
	end
end

legend_handles = findobj(h_fig,'Tag','legend');
set(legend_handles,'FontSize',legend_font_size);
