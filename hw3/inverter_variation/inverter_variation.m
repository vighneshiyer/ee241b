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

%% problem 1d monte carlo matlab sim
syms VDD;
syms delta_Vth;
C = 1.5e-15;
K = 1.7e-4;
V_th = 0.336;
alpha = 1.36;
sigma_Vth = 16.01e-3;
alpha_power_delay = (C * 0.5 * VDD) / (K * (VDD - V_th + delta_Vth)^alpha);

Vth_variations = [];
for i = 1:600
    Vth_variations = cat(1, Vth_variations, normrnd(0, sigma_Vth));
end

delays_105 = subs(alpha_power_delay, VDD, 1.05);
delays_105 = double(subs(delays_105, delta_Vth, Vth_variations));

delays_06 = subs(alpha_power_delay, VDD, 0.6);
delays_06 = double(subs(delays_06, delta_Vth, Vth_variations));
histfit(delays_105 / 1e-12);
hold on;
histfit(delays_06 / 1e-12);
title('Alpha-Power Law Based Delay w/ MATLAB Monte Carlo', 'Interpreter', 'Latex');
xlabel('Delay (ps)', 'Interpreter', 'Latex');
ylabel('Frequency', 'Interpreter', 'Latex');
