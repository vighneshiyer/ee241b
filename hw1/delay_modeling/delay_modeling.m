%% problem 2a, plotting inverter delay as a function of PMOS width
inverter_delay_file = fopen('inverter_delay_data3.txt');
% file is in format PMOS width (meters), low to high delay, high to low
% delay, temperature

inverter_delay_data = [];
tline = fgets(inverter_delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 6)
        inverter_delay_data = cat(1, inverter_delay_data, line_split(2:4));
    end
    tline = fgets(inverter_delay_file);
end
fclose(inverter_delay_file);

pmos_width = str2double(inverter_delay_data(:,1)) / 1e-9;
low_to_high_delay = str2double(inverter_delay_data(:,2)) / 1e-12;
high_to_low_delay = str2double(inverter_delay_data(:,3)) / 1e-12;
avg_prop_delay = (low_to_high_delay + high_to_low_delay)/2;
plot(pmos_width, low_to_high_delay);
hold on
plot(pmos_width, high_to_low_delay);
plot(pmos_width, avg_prop_delay);
xlabel('PMOS Width (nm)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
legend('Low-to-High Delay', 'High-to-Low Delay', 'Avg Propagation Delay');
[min_avg_prop_delay, i] = min(avg_prop_delay);
min_avg_prop_delay_pmos_width = pmos_width(i);
title('Propagation Delay of an Inverter Calculated using F04 Method')

%% plotting delay vs fanout for optimally sized inverter
delay_fanout_file = fopen('delay_fanout.txt');
% file is in format PMOS width (meters), low to high delay, high to low
% delay, temperature

delay_fanout_data = [];
tline = fgets(delay_fanout_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 6)
        delay_fanout_data = cat(1, delay_fanout_data, line_split(2:4));
    end
    tline = fgets(delay_fanout_file);
end
fclose(delay_fanout_file);

fanout = str2double(delay_fanout_data(2:114,1));
low_to_high_delay = str2double(delay_fanout_data(2:114,2)) / 1e-12;
high_to_low_delay = str2double(delay_fanout_data(2:114,3)) / 1e-12;
avg_prop_delay = (low_to_high_delay + high_to_low_delay)/2;
plot(fanout, low_to_high_delay);
hold on
plot(fanout, high_to_low_delay);
plot(fanout, avg_prop_delay);
xlabel('Fanout', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
title('Propagation Delay of an Optimally Sized Inverter with Increasing Fanout')

% now let's fit a curve
% params(1) = t_inv
% params(2) = gamma
% t_p = t_inv(gamma + f) where f is fanout
prop_delay_fn = @(params, data)params(1) .* (params(2) + data);
inverter_intrinsic_params = lsqcurvefit(prop_delay_fn, [10, 1.1], fanout, avg_prop_delay);
plot(fanout, prop_delay_fn(inverter_intrinsic_params, fanout));
legend('Low-to-High Delay', 'High-to-Low Delay', 'Avg Propagation Delay', 'Prop Delay Fn Fit');

%%
nand_delay_file = fopen('nand2_width_data.txt');

nand_delay_data = [];
tline = fgets(nand_delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 6)
        nand_delay_data = cat(1, nand_delay_data, line_split(2:3));
    end
    tline = fgets(nand_delay_file);
end
fclose(nand_delay_file);

nmos_width = str2double(nand_delay_data(:,1)) / 1e-9;
high_to_low_delay = str2double(nand_delay_data(:,2)) / 1e-12;
plot(nmos_width, high_to_low_delay);
hold on
xlabel('NMOS Width (nm)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
title('High-to-Low Delay of NAND2 Gate vs. NMOS Stack Width')
% 13.61 ps is the inverter high-to-low delay at optimal sizing, add a line
% there
hline = refline([0 13.61]);
hline.Color = 'r';
set(hline,'LineStyle',':');
text(205,13.7,'H-L Delay of Optimal Inverter')