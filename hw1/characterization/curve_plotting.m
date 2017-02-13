%%
% This script will plot the IDS vs VDS curves generated for the NMOS +
% PMOS
nmos_file = importdata('nmos_characterization.txt', ' ', 3);
nmos_file = nmos_file.data;
pmos_file = importdata('pmos_characterization.txt', ' ', 3);
%pmos_file = pmos_file.data;

% each line of this file corresponds to a value of V_GS and each entry in a
% given line corresponds to a value of I_DS for each V_DS

figure();
subplot(2, 2, 1)
hold on
for row = 1:8:106
   x_vals = linspace(0, 1.05, 106);
   plot(x_vals, abs(nmos_file(row,2:end)));
end
xlabel('V_{DS} (V)')
ylabel('I_{DS} (A)')
title('NMOS - V_{DS} vs. I_{DS} for V_{GS} from 0 \rightarrow 1.05V')

subplot(2, 2, 2)
hold on
for col = 2:8:107
    x_vals = linspace(0, 1.05, 106);
    plot(x_vals, abs(nmos_file(:,col)));
end
xlabel('V_{GS} (V)')
ylabel('I_{DS} (A)')
title('NMOS - V_{GS} vs. I_{DS} for V_{DS} from 0 \rightarrow 1.05V')

subplot(2, 2, 3)
hold on
for row = 1:5:106
   x_vals = linspace(-1.05, 0, 106);
   plot(x_vals, pmos_file(row,2:end));
end
xlabel('V_{DS} (V)')
ylabel('I_{DS} (A)')
title('PMOS - V_{DS} vs. I_{DS} for V_{GS} from 0 \rightarrow 1.05V')

subplot(2, 2, 4)
hold on
for col = 2:8:107
    x_vals = linspace(-1.05, 0, 106);
    plot(x_vals, pmos_file(:,col));
end
xlabel('V_{GS} (V)')
ylabel('I_{DS} (A)')
title('PMOS - V_{GS} vs. I_{DS} for V_{DS} from 0 \rightarrow 1.05V')

%% Now we extrapolate the Id-Vgs curve at low V_ds to find the threshold voltage
hold on
for col = 10:2:30
    x_vals = linspace(0, 1.05, 106);
    plot(x_vals, abs(nmos_file(:,col)));
end
xlabel('V_{GS} (V)')
ylabel('I_{DS} (A)')
title('NMOS - V_{GS} vs. I_{DS} for V_{DS} from 0 \rightarrow 1.05V')

