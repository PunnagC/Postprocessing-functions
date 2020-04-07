function [t_part1,t_part2,idx] = get_time_truncated(t_original,t_after,t_low)
%% This function cuts any vector arranged in ascending order into 2 parts
% part 1 = start of vector to set value
% part 2 = set value + 1 to end

if t_after >= t_original(end)
    error('Total time signal <= "t_after"')
elseif abs(t_original(end) - t_after) < t_low
    warning(['time considered for data is <= ',num2str(t_low),' sec(s)'])
    warning('Increase original time duration or reduce "t_after"')
end
t_length_orig = numel(t_original);
t_length_new  = numel(t_original(t_original >= t_after));
idx           = t_length_orig - t_length_new + 1;
t_part2       = t_original(idx:end); %truncated actual evalauation time vector
t_part1       = t_original(1:idx - 1);

end