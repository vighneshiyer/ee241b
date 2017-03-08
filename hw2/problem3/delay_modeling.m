%% problem 3a preface, plotting inverter delay as a function of PMOS width
inverter_delay_file = fopen('part_a/inverter_delay_pmos_sweep.txt');
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

%% problem 3b, monte carlo
monte_carlo_file = fopen('part_b/monte_carlo_data.txt');

monte_carlo_data = [];
tline = fgets(monte_carlo_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 5)
        monte_carlo_data = cat(1, monte_carlo_data, line_split(2:4));
    end
    tline = fgets(monte_carlo_file);
end
fclose(monte_carlo_file);
monte_carlo_hl_delay = str2double(monte_carlo_data(:,2)) / 1e-12;
monte_carlo_lh_delay = str2double(monte_carlo_data(:,3)) / 1e-12;
subplot(1, 2, 1);
histfit(monte_carlo_lh_delay);
xlabel('Delay (ps)', 'Interpreter', 'Latex');
ylabel('Frequency', 'Interpreter', 'Latex');
title('Low-to-High Delay of Optimal Inverter');
subplot(1, 2, 2);
histfit(monte_carlo_hl_delay);
xlabel('Delay (ps)', 'Interpreter', 'Latex');
ylabel('Frequency', 'Interpreter', 'Latex');
title('High-to-Low Delay of Optimal Inverter');

%% problem 3c, temperature variation
temp_file = fopen('part_c/temp_data.txt');

temp_data = [];
tline = fgets(temp_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 6)
        temp_data = cat(1, temp_data, line_split(2:4));
    end
    tline = fgets(temp_file);
end
fclose(temp_file);
temp = str2double(temp_data(:,1));
temp_lh_delay = str2double(temp_data(:,2)) / 1e-12;
temp_hl_delay = str2double(temp_data(:,3)) / 1e-12;
subplot(1, 2, 1);
plot(temp, temp_lh_delay);
xlabel('Temp (C)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
title('Low-to-High Delay of Optimal Inverter');
subplot(1, 2, 2);
plot(temp, temp_hl_delay);
xlabel('Temp (C)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
title('High-to-Low Delay of Optimal Inverter');