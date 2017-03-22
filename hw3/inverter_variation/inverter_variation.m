%% problem 1b. create matrix of monte carlo delays for each setting of vdd
delay_data_02 = [];
delay_file = fopen('delay_02');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_02 = cat(1, delay_data_02, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_03 = [];
delay_file = fopen('delay_03');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_03 = cat(1, delay_data_03, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_04 = [];
delay_file = fopen('delay_04');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_04 = cat(1, delay_data_04, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_05 = [];
delay_file = fopen('delay_05');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_05 = cat(1, delay_data_05, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_06 = [];
delay_file = fopen('delay_06');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_06 = cat(1, delay_data_06, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_07 = [];
delay_file = fopen('delay_07');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_07 = cat(1, delay_data_07, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_08 = [];
delay_file = fopen('delay_08');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_08 = cat(1, delay_data_08, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_09 = [];
delay_file = fopen('delay_09');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_09 = cat(1, delay_data_09, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_10 = [];
delay_file = fopen('delay_10');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_10 = cat(1, delay_data_10, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

delay_data_105 = [];
delay_file = fopen('delay_105');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 4)
        delay_data_105 = cat(1, delay_data_105, str2double(line_split(3)));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

%% problem 1b plotting
delay_data = [delay_data_02, delay_data_03, delay_data_04, delay_data_05, delay_data_06, delay_data_07, delay_data_08, delay_data_09, delay_data_10,delay_data_105];
voltages = [0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.05];
mean_delays = nanmean(delay_data);
sd_delays = sqrt(nanvar(delay_data));

% sigma and mu vs VDD plotting
subplot(1, 2, 1);
semilogy(voltages, mean_delays / 1e-12);
title('Average delay of INVX0\_RVT', 'Interpreter', 'Latex');
xlabel('$V_{DD}$ (V)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
subplot(1, 2, 2);
semilogy(voltages, sd_delays / 1e-12);
title('SD of delay of INVX0\_RVT', 'Interpreter', 'Latex');
xlabel('$V_{DD}$ (V)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');

%% problem 1b plotting
% sigma/mu vs VDD plotting
sd_over_mean = sd_delays ./ mean_delays;
plot(voltages, sd_over_mean);
title('Relative Variation with respect to Delay', 'Interpreter', 'Latex');
xlabel('$V_{DD}$ (V)', 'Interpreter', 'Latex');
ylabel('$\sigma / \mu$', 'Interpreter', 'Latex');

%% problem 1b plotting
% delay of a 6 sigma cell relative to the mean vs VDD
six_sigma_delay = mean_delays + (6 .* sd_delays);
semilogy(voltages, six_sigma_delay / 1e-12);
hold on;
semilogy(voltages, mean_delays / 1e-12);
title('$6 \sigma$ Delay vs. Average Delay', 'Interpreter', 'Latex');
xlabel('$V_{DD}$ (V)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
legend({'6$\sigma$ delay', 'average delay'}, 'Interpreter', 'Latex');

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