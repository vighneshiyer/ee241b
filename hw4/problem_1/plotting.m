%% problem 1b - variation of delays across voltages (replica tracking)
delay_data = [];
delay_file = fopen('data.txt');
tline = fgets(delay_file);
while ischar(tline)
    line_split = strsplit(tline);
    line_size = size(line_split);
    if (line_size(2) == 8)
        delay_data = cat(1, delay_data, line_split(3:7));
    end
    tline = fgets(delay_file);
end
fclose(delay_file);

vdd = str2double(delay_data(:,5));
replica_delay = str2double(delay_data(:,4)) / 1e-9;
nor_delay = str2double(delay_data(:,3)) / 1e-9;
nand_delay = str2double(delay_data(:,2)) / 1e-9;
inv_delay = str2double(delay_data(:,1)) / 1e-9;

plot(vdd, inv_delay ./ replica_delay);
hold on;
plot(vdd, nand_delay ./ replica_delay);
plot(vdd, nor_delay ./ replica_delay);
xlabel('VDD');
ylabel('Actual Delay / Replica Delay');
title('Tracking of Replica Delay with Actual Delay Across Voltages');
legend('20 FO4 Inverter Chain', 'NAND Chain', 'NOR Chain');