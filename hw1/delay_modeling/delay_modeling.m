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
plot(pmos_width, low_to_high_delay);
hold on
plot(pmos_width, high_to_low_delay);
plot(pmos_width, (low_to_high_delay + high_to_low_delay)/2);
xlabel('PMOS Width (nm)', 'Interpreter', 'Latex');
ylabel('Delay (ps)', 'Interpreter', 'Latex');
legend('Low-to-High Delay', 'High-to-Low Delay', 'Avg Propagation Delay');
title('Propagation Delay of an Inverter Calculated using F04 Method')