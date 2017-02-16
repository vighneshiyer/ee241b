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
    linear_fit = fitlm(x_vals(60:100), y_vals(60:100));
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
    linear_fit = fitlm(x_vals(60:100), y_vals(60:100));
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
    linear_fit = fitlm(x_vals(10:50), y_vals(10:50));
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
    linear_fit = fitlm(x_vals(10:50), y_vals(10:50));
    intercept = linear_fit.Coefficients.Estimate(1);
    slope = linear_fit.Coefficients.Estimate(2);
    threshold_voltage_est = -intercept / slope;
    plot(1.05 - ((col - 2) * 0.01), threshold_voltage_est, '*');
end
xlabel('$|V_{DS}|$ (V)', 'Interpreter', 'Latex')
ylabel('$V_{th}$ (V)', 'Interpreter', 'Latex')
title('PMOS - Threshold Voltage vs $V_{DS}$', 'Interpreter', 'Latex')

%% Fitting velocity saturation model
% params(1) = mu * C_ox
% params(2) = E_C * L
% params(3) = V_th (used when V_th fitting is desired)
W_L = 1e-6/32e-9;
subplot(1, 2, 1);
i_d_sat_model = @(params, data)((W_L * params(1)/2) .* params(2)) .* (((data - params(3)).^2)./((data - params(3)) + params(2)));
xdata = linspace(0, 1.05, 106);
ydata = abs(nmos_file(:,107))';
xdata_fit = xdata(40:end);
ydata_fit = ydata(40:end);
%k_est = 31.25; %(3.9 * 8.854e-15/2.39e-9) * 30.4;
k_est = 0.00001;
params0 = [k_est, 0.3, .38];
params = lsqcurvefit(i_d_sat_model, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_sat_model(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('NMOS Fitting $I_{DSat}$ @ $V_{DS}$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');

subplot(1, 2, 2);
xdata = linspace(-1.05, 0, 106);
ydata = abs(pmos_file(:,2))';
xdata_fit = xdata(15:60);
ydata_fit = ydata(15:60);
%k_est = 31.25; %(3.9 * 8.854e-15/2.39e-9) * 30.4;
k_est = 0.000001;
params0 = [k_est, 2, -.50];
params = lsqcurvefit(i_d_sat_model, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_sat_model(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('PMOS Fitting $I_{DSat}$ @ $|V_{DS}|$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');


%% Fitting alpha-power law
% params(1) = alpha
% params(2) = K
% params(3) = V_th
subplot(1, 2, 1);
i_d_alpha_power = @(params, data)params(2) .* (data - params(3)) .^ params(1);
xdata = linspace(0, 1.05, 106);
ydata = abs(nmos_file(:,107))';
xdata_fit = xdata(40:100);
ydata_fit = ydata(40:100);
k_est = 0.0001;
params0 = [1.2, k_est, .45];
params = lsqcurvefit(i_d_alpha_power, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_alpha_power(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('NMOS Fitting Alpha-Power @ $V_{DS}$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');

subplot(1, 2, 2);
xdata = linspace(-1.05, 0, 106);
ydata = abs(pmos_file(:,2))';
xdata_fit = xdata(7:60);
ydata_fit = ydata(7:60);
k_est = 0.0001;
params0 = [1.2, k_est, -.38];
params = lsqcurvefit(i_d_alpha_power, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_alpha_power(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('PMOS Fitting Alpha-Power @ $|V_{DS}|$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');

%% Fitting alpha-power law with alpha fixed to 1
% params(1) = K
% params(2) = V_th
subplot(1, 2, 1);
i_d_alpha_power = @(params, data)params(1) .* (data - params(2));
xdata = linspace(0, 1.05, 106);
ydata = abs(nmos_file(:,107))';
xdata_fit = xdata(40:100);
ydata_fit = ydata(40:100);
k_est = 0.0001;
params0 = [k_est, .45];
params = lsqcurvefit(i_d_alpha_power, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_alpha_power(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('NMOS Fitting Alpha-Power ($\alpha=1$) @ $V_{DS}$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');

subplot(1, 2, 2);
xdata = linspace(-1.05, 0, 106);
ydata = abs(pmos_file(:,2))';
xdata_fit = xdata(7:60);
ydata_fit = ydata(7:60);
k_est = 0.0001;
params0 = [k_est, -.38];
params = lsqcurvefit(i_d_alpha_power, params0, xdata_fit, ydata_fit);

times = linspace(xdata_fit(1), xdata_fit(end));
plot(xdata, ydata, times, i_d_alpha_power(params, times), '--');
xlabel('$V_{GS}$ (V)', 'Interpreter', 'Latex')
ylabel('$I_{DS}$ (A)', 'Interpreter', 'Latex')
title('PMOS Fitting Alpha-Power ($\alpha=1$) @ $|V_{DS}|$ = 1.05 V', 'Interpreter', 'Latex')
legend('Simulation Data', 'Best Fit Curve');