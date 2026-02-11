% Section C
% t-SNE
clear
close all

% Load all preprocessed data files

% PLA objects
cylinder_pla = load("PR_CW_mat/cylinder_papillarray_single.mat");
hexagon_pla = load("PR_CW_mat/hexagon_papillarray_single.mat");
square_pla = load("PR_CW_mat/oblong_papillarray_single.mat");

% TPU objects
cylinder_TPU = load("PR_CW_mat/cylinder_TPU_papillarray_single.mat");
hexagon_TPU = load("PR_CW_mat/hexagon_TPU_papillarray_single.mat");
square_TPU = load("PR_CW_mat/oblong_TPU_papillarray_single.mat");

% Rubber objects
cylinder_rub = load("PR_CW_mat/cylinder_rubber_papillarray_single.mat");
hexagon_rub = load("PR_CW_mat/hexagon_rubber_papillarray_single.mat");
square_rub = load("PR_CW_mat/oblong_rubber_papillarray_single.mat");

color_tpu = [1, 0, 0]; % Red for TPU 
color_rub = [0, 1, 0]; % Green for Rubber 
color_pla = [0, 0, 1]; % Glue for PLA

%  C.1 t-SNE on Cylinders

% Extract force data 13:15
pla_cyl = cylinder_pla.sensor_matrices_force(cylinder_pla.pks_locs, 13:15);
tpu_cyl = cylinder_TPU.sensor_matrices_force(cylinder_TPU.pks_locs, 13:15);
rub_cyl = cylinder_rub.sensor_matrices_force(cylinder_rub.pks_locs, 13:15);

% Combine all cylinder data
cylinders = [pla_cyl; tpu_cyl; rub_cyl];

pla_indxs = 1:21;
tpu_indxs = 22:42;
rub_indxs = 43:63;

% Standardize the data
cylinders_std = zscore(cylinders);

% t-SNE with two different perplexity values for cylinders

% reproducibility
rng(42);

perplexity_1 = 5;  % Lower value - emphasizes local structure
perplexity_2 = 15;  % Higher value - emphasizes global structure


% t-SNE with first perplexity value
fprintf('t-SNE with perplexity = %d...\n', perplexity_1);
[Y_cyl_p1, loss_cyl_p1] = tsne(cylinders_std, 'Perplexity', perplexity_1, 'NumDimensions', 2);
fprintf('Loss: %.4f\n', loss_cyl_p1);


% t-SNE with second perplexity value
fprintf('Running t-SNE with perplexity = %d...\n', perplexity_2);
[Y_cyl_p2, loss_cyl_p2] = tsne(cylinders_std, 'Perplexity', perplexity_2, 'NumDimensions', 2);
fprintf('Loss : %.4f\n\n', loss_cyl_p2);

% Plot both perplexity results side by side
figure('Position', [100, 100, 1400, 600]);

% Subplot 1: Lower perplexity
subplot(1,2,1)
scatter(Y_cyl_p1(pla_indxs,1), Y_cyl_p1(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_cyl_p1(tpu_indxs,1), Y_cyl_p1(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_cyl_p1(rub_indxs,1), Y_cyl_p1(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('t-SNE Dimension 1', 'FontSize', 12);
ylabel('t-SNE Dimension 2', 'FontSize', 12);
title(sprintf('Cylinders: t-SNE (Perplexity=%d)\nLoss = %.4f', perplexity_1, loss_cyl_p1), ...
    'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

% Subplot 2: Higher perplexity
subplot(1,2,2)
scatter(Y_cyl_p2(pla_indxs,1), Y_cyl_p2(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_cyl_p2(tpu_indxs,1), Y_cyl_p2(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_cyl_p2(rub_indxs,1), Y_cyl_p2(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('t-SNE Dimension 1', 'FontSize', 12);
ylabel('t-SNE Dimension 2', 'FontSize', 12);
title(sprintf('Cylinders: t-SNE (Perplexity=%d)\nLoss = %.4f', perplexity_2, loss_cyl_p2), ...
    'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

sgtitle('t-SNE Analysis: Cylinders with Different Perplexity Values', ...
    'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'C1a_Cylinders_tSNE_Comparison.fig');
saveas(gcf, 'C1a_Cylinders_tSNE_Comparison.png');

fprintf('[C.1.a] Figure saved.\n\n');

% C.1.b t-SNE on Hexagons

fprintf('[C.1.b] Applying t-SNE to hexagon objects (middle papillae)...\n');

% Extract middle papillae (P4) force data for hexagons
pla_hex = hexagon_pla.sensor_matrices_force(hexagon_pla.pks_locs, 13:15);
tpu_hex = hexagon_TPU.sensor_matrices_force(hexagon_TPU.pks_locs, 13:15);
rub_hex = hexagon_rub.sensor_matrices_force(hexagon_rub.pks_locs, 13:15);

% Combine all hexagon data
hexagons = [pla_hex; tpu_hex; rub_hex];

pla_indxs = 1:21;
tpu_indxs = 22:42;
rub_indxs = 43:63;

% Standardize the data
hexagons_std = zscore(hexagons);


% Use the same perplexity values as for cylinders
fprintf('Running t-SNE with perplexity = %d...\n', perplexity_1);
[Y_hex_p1, loss_hex_p1] = tsne(hexagons_std, 'Perplexity', perplexity_1, 'NumDimensions', 2);
fprintf('Loss: %.4f\n', loss_hex_p1);

fprintf('Running t-SNE with perplexity = %d...\n', perplexity_2);
[Y_hex_p2, loss_hex_p2] = tsne(hexagons_std, 'Perplexity', perplexity_2, 'NumDimensions', 2);
fprintf('    Loss : %.4f\n\n', loss_hex_p2);

% Plot both perplexity results for hexagons
figure('Position', [100, 100, 1400, 600]);

% Subplot 1: Lower perplexity
subplot(1,2,1)
scatter(Y_hex_p1(pla_indxs,1), Y_hex_p1(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_hex_p1(tpu_indxs,1), Y_hex_p1(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_hex_p1(rub_indxs,1), Y_hex_p1(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('t-SNE Dimension 1', 'FontSize', 12);
ylabel('t-SNE Dimension 2', 'FontSize', 12);
title(sprintf('Hexagons: t-SNE (Perplexity=%d)\nLoss = %.4f', perplexity_1, loss_hex_p1), ...
    'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

% Subplot 2: Higher perplexity
subplot(1,2,2)
scatter(Y_hex_p2(pla_indxs,1), Y_hex_p2(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_hex_p2(tpu_indxs,1), Y_hex_p2(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_hex_p2(rub_indxs,1), Y_hex_p2(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('t-SNE Dimension 1', 'FontSize', 12);
ylabel('t-SNE Dimension 2', 'FontSize', 12);
title(sprintf('Hexagons: t-SNE (Perplexity=%d)\nLoss = %.4f', perplexity_2, loss_hex_p2), ...
    'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

sgtitle('t-SNE: Hexagons with Different Perplexity Values', ...
    'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'C1b_Hexagons_tSNE_Comparison.fig');
saveas(gcf, 'C1b_Hexagons_tSNE_Comparison.png');

fprintf('[C.1.b] Figure saved.\n\n');

% Summary comparison figure (for appendix)
figure('Position', [100, 100, 1400, 900]);

% Cylinders - Perplexity 1
subplot(2,2,1)
scatter(Y_cyl_p1(pla_indxs,1), Y_cyl_p1(pla_indxs,2), ...
    80, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_cyl_p1(tpu_indxs,1), Y_cyl_p1(tpu_indxs,2), ...
    80, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_cyl_p1(rub_indxs,1), Y_cyl_p1(rub_indxs,2), ...
    80, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('Dimension 1', 'FontSize', 10);
ylabel('Dimension 2', 'FontSize', 10);
title(sprintf('Cylinders (Perp=%d, Loss=%.3f)', perplexity_1, loss_cyl_p1), 'FontSize', 11);
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

% Cylinders - Perplexity 2
subplot(2,2,2)
scatter(Y_cyl_p2(pla_indxs,1), Y_cyl_p2(pla_indxs,2), ...
    80, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_cyl_p2(tpu_indxs,1), Y_cyl_p2(tpu_indxs,2), ...
    80, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_cyl_p2(rub_indxs,1), Y_cyl_p2(rub_indxs,2), ...
    80, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('Dimension 1', 'FontSize', 10);
ylabel('Dimension 2', 'FontSize', 10);
title(sprintf('Cylinders (Perp=%d, Loss=%.3f)', perplexity_2, loss_cyl_p2), 'FontSize', 11);
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

% Hexagons - Perplexity 1
subplot(2,2,3)
scatter(Y_hex_p1(pla_indxs,1), Y_hex_p1(pla_indxs,2), ...
    80, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_hex_p1(tpu_indxs,1), Y_hex_p1(tpu_indxs,2), ...
    80, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_hex_p1(rub_indxs,1), Y_hex_p1(rub_indxs,2), ...
    80, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('Dimension 1', 'FontSize', 10);
ylabel('Dimension 2', 'FontSize', 10);
title(sprintf('Hexagons (Perp=%d, Loss=%.3f)', perplexity_1, loss_hex_p1), 'FontSize', 11);
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

% Hexagons - Perplexity 2
subplot(2,2,4)
scatter(Y_hex_p2(pla_indxs,1), Y_hex_p2(pla_indxs,2), ...
    80, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(Y_hex_p2(tpu_indxs,1), Y_hex_p2(tpu_indxs,2), ...
    80, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(Y_hex_p2(rub_indxs,1), Y_hex_p2(rub_indxs,2), ...
    80, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('Dimension 1', 'FontSize', 10);
ylabel('Dimension 2', 'FontSize', 10);
title(sprintf('Hexagons (Perp=%d, Loss=%.3f)', perplexity_2, loss_hex_p2), 'FontSize', 11);
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

sgtitle('t-SNE Summary: Cylinders vs Hexagons', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'C_Summary_tSNE_All.fig');
saveas(gcf, 'C_Summary_tSNE_All.png');

