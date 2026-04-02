clc
close all
clear

%% 1. Dirlist 
load("Dirlist.mat")
load("net_weight.mat")
numPatients = length(Dirlist_new);      
assert(numPatients == 90);

rng(48); 
all_patient_ids = 1:numPatients;

test_patient_ids = randsample(all_patient_ids, fix(0.2*numPatients));   
train_cv_patient_ids = setdiff(all_patient_ids, test_patient_ids); 

% Step 2: 
train_data = [];
train_patient_ranges = [];  
row_counter = 1;

for p = train_cv_patient_ids
    inp = Dirlist_new(p).input; 
    out = Dirlist_new(p).output;  
    Np = size(inp, 1);
    
    sbp_block = [inp(:,1:5), out(:,1)];    
    dbp_block = [inp(:,[1:4,6]), out(:,2)];  
    
    patient_block = [sbp_block; dbp_block];  
    train_data = [train_data; patient_block];
    
    start_row = row_counter;
    end_row   = row_counter + 2*Np - 1;
    train_patient_ranges(end+1, :) = [start_row, end_row];
    row_counter = end_row + 1;
end

test_data = [];
for p = test_patient_ids
    inp = Dirlist_new(p).input;
    out = Dirlist_new(p).output;
    Np = size(inp, 1);
    
    sbp_block = [inp(:,1:5), out(:,1)];
    dbp_block = [inp(:,[1:4,6]), out(:,2)];
    
    patient_block = [sbp_block; dbp_block];
    test_data = [test_data; patient_block];
end

Ps = train_data(:,1); Pd = train_data(:,2); Ds = train_data(:,3);
Dd = train_data(:,4); Dt = train_data(:,5);
As = Ds.^2; Ad = Dd.^2;
hA = Ad ./ (As - Ad);
alpha = log(Ps ./ Pd) .* hA;
k = (Ps - Pd) ./ (As - Ad)

x_train = [ Pd, Ds, Dd, Dt,alpha ]';  
t_train = train_data(:,6)';

Ps_t = test_data(:,1); Pd_t = test_data(:,2); Ds_t = test_data(:,3);
Dd_t = test_data(:,4); Dt_t = test_data(:,5);
As_t = Ds_t.^2; Ad_t = Dd_t.^2;
hA_t = Ad_t ./ (As_t - Ad_t);
alpha_t = log(Ps_t ./ Pd_t) .* hA_t;
k_t = (Ps_t - Pd_t) ./ (As_t - Ad_t)

x_test_raw = [ Pd_t, Ds_t, Dd_t, Dt_t, alpha_t]'; 
t_test_raw = test_data(:,6)';

[x_train, ps_x] = mapminmax(x_train, 0, 1);
[t_train, ps_t] = mapminmax(t_train, 0, 1);

x_test = mapminmax('apply', x_test_raw, ps_x);
t_test = mapminmax('apply', t_test_raw, ps_t); 


%%
y_test_norm = net_final(x_test);
y_test_pred = mapminmax('reverse', y_test_norm, ps_t);  
t_test_true = t_test_raw;  

mse_test = mean((y_test_pred - t_test_true).^2);
mae_test = mean(abs(y_test_pred - t_test_true));
fprintf('MSE = %.4f, MAE = %.4f mmHg\n', mse_test, mae_test);

is_sbp_test = false(size(t_test_true));
is_dbp_test = false(size(t_test_true));
row = 1;
for p = test_patient_ids
    Np = size(Dirlist_new(p).input, 1);
    is_sbp_test(row : row + Np - 1) = true;
    is_dbp_test(row + Np : row + 2*Np - 1) = true;
    row = row + 2*Np;
end
%% Visualize
% SBP
figure;
diff_sbp = y_test_pred(is_sbp_test) - t_test_true(is_sbp_test);
mean_sbp = (y_test_pred(is_sbp_test) + t_test_true(is_sbp_test)) / 2;
scatter(mean_sbp, diff_sbp, 'filled'); grid on; hold on;
mean_diff = mean(diff_sbp); sd_diff = std(diff_sbp);
yline(mean_diff, 'k--', 'LineWidth', 1.2);
yline(mean_diff + 1.96*sd_diff, 'r--', 'LineWidth', 1.2);
yline(mean_diff - 1.96*sd_diff, 'r--', 'LineWidth', 1.2);

%%
% DBP
figure;
diff_dbp = y_test_pred(is_dbp_test) - t_test_true(is_dbp_test);
mean_dbp = (y_test_pred(is_dbp_test) + t_test_true(is_dbp_test)) / 2;

scatter(mean_dbp, diff_dbp, 'filled'); 
grid on; hold on;

mean_diff_dbp = mean(diff_dbp);
sd_diff_dbp   = std(diff_dbp);
LOA_upper_dbp = mean_diff_dbp + 1.96 * sd_diff_dbp;
LOA_lower_dbp = mean_diff_dbp - 1.96 * sd_diff_dbp;
% 
yline(mean_diff_dbp, 'k--', 'LineWidth', 1.2);
yline(LOA_upper_dbp, 'r--', 'LineWidth', 1.2);
yline(LOA_lower_dbp, 'r--', 'LineWidth', 1.2);

