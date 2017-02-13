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
subplot(2, 2, 1);
hold on
for col = 5:10:60
    x_vals = linspace(0, 1.05, 106);
    y_vals = abs(nmos_file(:,col))';
    linear_fit = fitlm(x_vals(40:60), y_vals(40:60));
    plot(linear_fit)
    plot(x_vals, abs(nmos_file(:,col)));
end
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('NMOS - $V_{GS}$ vs. $I_{DS}$ for $V_{DS}$ from 0 $\rightarrow$ 600 mV', 'Interpreter', 'Latex')

subplot(2, 2, 2);
hold on
for col = 5:5:60
    x_vals = linspace(0, 1.05, 106);
    y_vals = abs(nmos_file(:,col))';
    linear_fit = fitlm(x_vals(40:60), y_vals(40:60));
    intercept = linear_fit.Coefficients.Estimate(1);
    slope = linear_fit.Coefficients.Estimate(2);
    threshold_voltage_est = -intercept / slope;
    plot((col - 2) * 0.01, threshold_voltage_est, '*');
end
xlabel('$V_{DS}$ (V)', 'Interpreter', 'Latex')
ylabel('$V_{th}$ (V)', 'Interpreter', 'Latex')
title('NMOS - Threshold Voltage vs $V_{DS}$', 'Interpreter', 'Latex')

subplot(2, 2, 3);
hold on
for col = 60:10:100
    x_vals = linspace(-1.05, 0, 106);
    y_vals = pmos_file(:,col)';
    linear_fit = fitlm(x_vals(40:70), y_vals(40:70));
    plot(linear_fit)
    plot(x_vals, pmos_file(:,col));
end
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('PMOS - $V_{GS}$ vs. $I_{DS}$ for $V_{DS}$ from 0 $\rightarrow$ 600 mV', 'Interpreter', 'Latex')

subplot(2, 2, 4);
hold on
for col = 60:5:100
    x_vals = linspace(-1.05, 0, 106);
    y_vals = pmos_file(:,col)';
    linear_fit = fitlm(x_vals(40:70), y_vals(40:70));
    intercept = linear_fit.Coefficients.Estimate(1);
    slope = linear_fit.Coefficients.Estimate(2);
    threshold_voltage_est = -intercept / slope;
    plot(1.05 - ((col - 2) * 0.01), threshold_voltage_est, '*');
end
xlabel('$|V_{DS}|$ (V)', 'Interpreter', 'Latex')
ylabel('$V_{th}$ (V)', 'Interpreter', 'Latex')
title('PMOS - Threshold Voltage vs $V_{DS}$', 'Interpreter', 'Latex')

%% Fitting velocity saturation model
i_d_sat_model = @(params, data)(params(1)/2)