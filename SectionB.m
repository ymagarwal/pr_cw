% Section B
% Principal Component Analysis (PCA)
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
color_pla = [0, 0, 1];

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
% Perform PCA
[pcs_cyl, scores_cyl, latent_cyl, ~, explained_cyl] = pca(cylinders_std);

fprintf('Explained by PC1: %.2f%%\n', explained_cyl(1));
fprintf('Explained by PC2: %.2f%%\n', explained_cyl(2));
fprintf('Explained by PC3: %.2f%%\n\n', explained_cyl(3));

% B.1.a Plot data with PC

figure('Position', [100, 100, 900, 700]);
scatter3(cylinders_std(pla_indxs,1), cylinders_std(pla_indxs,2), cylinders_std(pla_indxs,3), ...
    80, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter3(cylinders_std(tpu_indxs,1), cylinders_std(tpu_indxs,2), cylinders_std(tpu_indxs,3), ...
    80, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter3(cylinders_std(rub_indxs,1), cylinders_std(rub_indxs,2), cylinders_std(rub_indxs,3), ...
    80, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);

% Scale factor for PC axes visualization
scale_factor = 3;
% Plot PC1 axis
v1 = pcs_cyl(:,1) * scale_factor;
plot3([-v1(1) v1(1)], [-v1(2) v1(2)], [-v1(3) v1(3)], ...
    'k-', 'LineWidth', 3, 'DisplayName', 'PC1');

% Plot PC2 axis
v2 = pcs_cyl(:,2) * scale_factor;
plot3([-v2(1) v2(1)], [-v2(2) v2(2)], [-v2(3) v2(3)], ...
    'm-', 'LineWidth', 3, 'DisplayName', 'PC2');

% Plot PC3 axis
v3 = pcs_cyl(:,3) * scale_factor;
plot3([-v3(1) v3(1)], [-v3(2) v3(2)], [-v3(3) v3(3)], ...
    'c-', 'LineWidth', 3, 'DisplayName', 'PC3');

xlabel('F_X', 'FontSize', 12);
ylabel('F_Y', 'FontSize', 12);
zlabel('Standardised F_Z', 'FontSize', 12);
title('Standardised Data with Principal Components', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 10);
grid on;
view(45, 30);

saveas(gcf, 'B1a_Cylinders_PCA_3D.fig');
saveas(gcf, 'B1a_Cylinders_PCA_3D.png');

fprintf('[B.1.a] Figure saved.\n');

% B.1.b Reduce to 2D

figure('Position', [100, 100, 800, 600]);
scatter(scores_cyl(pla_indxs,1), scores_cyl(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_cyl(tpu_indxs,1), scores_cyl(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_cyl(rub_indxs,1), scores_cyl(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);

xlabel(sprintf('PC1 (%.1f%% variance)', explained_cyl(1)), 'FontSize', 12);
ylabel(sprintf('PC2 (%.1f%% variance)', explained_cyl(2)), 'FontSize', 12);
title('2D PCA Projection for Cylinders', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

saveas(gcf, 'B1b_Cylinders_PCA_2D.fig');
saveas(gcf, 'B1b_Cylinders_PCA_2D.png');


% B.1.c 1D number lines

figure('Position', [100, 100, 1000, 800]);
% PC1 distribution
subplot(3,1,1)
scatter(scores_cyl(pla_indxs,1), zeros(size(scores_cyl(pla_indxs,1))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_cyl(tpu_indxs,1), zeros(size(scores_cyl(tpu_indxs,1))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_cyl(rub_indxs,1), zeros(size(scores_cyl(rub_indxs,1))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC1 (%.1f%% variance)', explained_cyl(1)), 'FontSize', 11);
title('Cylinders PC1', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

% PC2 distribution
subplot(3,1,2)
scatter(scores_cyl(pla_indxs,2), zeros(size(scores_cyl(pla_indxs,2))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_cyl(tpu_indxs,2), zeros(size(scores_cyl(tpu_indxs,2))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_cyl(rub_indxs,2), zeros(size(scores_cyl(rub_indxs,2))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC2 (%.1f%% variance)', explained_cyl(2)), 'FontSize', 11);
title('Cylinders PC2', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

% PC3 distribution
subplot(3,1,3)
scatter(scores_cyl(pla_indxs,3), zeros(size(scores_cyl(pla_indxs,3))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_cyl(tpu_indxs,3), zeros(size(scores_cyl(tpu_indxs,3))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_cyl(rub_indxs,3), zeros(size(scores_cyl(rub_indxs,3))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC3 (%.1f%% variance)', explained_cyl(3)), 'FontSize', 11);
title('Cylinders PC3', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

sgtitle('Number Lines on PCs for Cylinders', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'B1c_Cylinders_1D_PCs.fig');
saveas(gcf, 'B1c_Cylinders_1D_PCs.png');


% PCA on Squares

% Extract middle papillae (P4) force data
pla_sq = square_pla.sensor_matrices_force(square_pla.pks_locs, 13:15);
tpu_sq = square_TPU.sensor_matrices_force(square_TPU.pks_locs, 13:15);
rub_sq = square_rub.sensor_matrices_force(square_rub.pks_locs, 13:15);

% Combine all oblong data
squares = [pla_sq; tpu_sq; rub_sq];

% Create indices for each material
pla_indxs_sq = 1:21;
tpu_indxs_sq = 22:42;
rub_indxs_sq = 43:63;

% Standardize the data
squares_std = zscore(squares);

% Perform PCA
[pcs_sq, scores_sq, latent_sq, ~, explained_sq] = pca(squares_std);

fprintf('Explained by PC1: %.2f%%\n', explained_sq(1));
fprintf('Explained by PC2: %.2f%%\n', explained_sq(2));
fprintf('Explained by PC3: %.2f%%\n\n', explained_sq(3));

% 2D PCA and number lines for Squares

% 2D Projection
figure('Position', [100, 100, 800, 600]);
scatter(scores_sq(pla_indxs_sq,1), scores_sq(pla_indxs_sq,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_sq(tpu_indxs_sq,1), scores_sq(tpu_indxs_sq,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_sq(rub_indxs_sq,1), scores_sq(rub_indxs_sq,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);

xlabel(sprintf('PC1 (%.1f%% variance)', explained_sq(1)), 'FontSize', 12);
ylabel(sprintf('PC2 (%.1f%% variance)', explained_sq(2)), 'FontSize', 12);
title('2D PCA Projection for Squares', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
axis equal;

saveas(gcf, 'B2a_Oblongs_PCA_2D.fig');
saveas(gcf, 'B2a_Oblongs_PCA_2D.png');

% 1D Number Lines
figure('Position', [100, 100, 1000, 800]);

% PC1 distribution
subplot(3,1,1)
scatter(scores_sq(pla_indxs_sq,1), zeros(size(scores_sq(pla_indxs_sq,1))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_sq(tpu_indxs_sq,1), zeros(size(scores_sq(tpu_indxs_sq,1))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_sq(rub_indxs_sq,1), zeros(size(scores_sq(rub_indxs_sq,1))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC1 (%.1f%% variance)', explained_sq(1)), 'FontSize', 11);
title('Squares PC1', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

% PC2 distribution
subplot(3,1,2)
scatter(scores_sq(pla_indxs_sq,2), zeros(size(scores_sq(pla_indxs_sq,2))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_sq(tpu_indxs_sq,2), zeros(size(scores_sq(tpu_indxs_sq,2))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_sq(rub_indxs_sq,2), zeros(size(scores_sq(rub_indxs_sq,2))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC2 (%.1f%% variance)', explained_sq(2)), 'FontSize', 11);
title('Squares PC2', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

% PC3 distribution
subplot(3,1,3)
scatter(scores_sq(pla_indxs_sq,3), zeros(size(scores_sq(pla_indxs_sq,3))), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_sq(tpu_indxs_sq,3), zeros(size(scores_sq(tpu_indxs_sq,3))), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_sq(rub_indxs_sq,3), zeros(size(scores_sq(rub_indxs_sq,3))), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC3 (%.1f%% variance)', explained_sq(3)), 'FontSize', 11);
title('Squares PC3', 'FontSize', 12);
legend('Location', 'best', 'FontSize', 10);
ylim([-0.5 0.5]);
yticks([]);
grid on;

sgtitle('Number Lines on PCs for Cylinders', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'B2a_Oblongs_1D_PCs.fig');
saveas(gcf, 'B2a_Oblongs_1D_PCs.png');

% PCA on 27D


% B.3.a 2D PCA projections for all shapes

pla_cyl_all = cylinder_pla.sensor_matrices_force(cylinder_pla.pks_locs, :);
tpu_cyl_all = cylinder_TPU.sensor_matrices_force(cylinder_TPU.pks_locs, :);
rub_cyl_all = cylinder_rub.sensor_matrices_force(cylinder_rub.pks_locs, :);
cylinders_all = [pla_cyl_all; tpu_cyl_all; rub_cyl_all];
cylinders_all_std = zscore(cylinders_all);
[~, scores_cyl_all, ~, ~, explained_cyl_all] = pca(cylinders_all_std);

pla_hex_all = hexagon_pla.sensor_matrices_force(hexagon_pla.pks_locs, :);
tpu_hex_all = hexagon_TPU.sensor_matrices_force(hexagon_TPU.pks_locs, :);
rub_hex_all = hexagon_rub.sensor_matrices_force(hexagon_rub.pks_locs, :);
hexagons_all = [pla_hex_all; tpu_hex_all; rub_hex_all];
hexagons_all_std = zscore(hexagons_all);
[~, scores_hex_all, ~, ~, explained_hex_all] = pca(hexagons_all_std);

pla_sq_all = square_pla.sensor_matrices_force(square_pla.pks_locs, :);
tpu_sq_all = square_TPU.sensor_matrices_force(square_TPU.pks_locs, :);
rub_sq_all = square_rub.sensor_matrices_force(square_rub.pks_locs, :);
oblongs_all = [pla_sq_all; tpu_sq_all; rub_sq_all];
oblongs_all_std = zscore(oblongs_all);
[~, scores_sq_all, ~, ~, explained_sq_all] = pca(oblongs_all_std);

pla_indxs = 1:21;
tpu_indxs = 22:42;
rub_indxs = 43:63;

PCA_features_bagging = [scores_cyl_all; scores_hex_all; scores_sq_all];

% Create Ground Truth labels for the 9 objects (3 shapes x 3 materials)
labels = [repmat({'Cyl_PLA'}, 21, 1); repmat({'Cyl_TPU'}, 21, 1); repmat({'Cyl_Rub'}, 21, 1); ...
          repmat({'Hex_PLA'}, 21, 1); repmat({'Hex_TPU'}, 21, 1); repmat({'Hex_Rub'}, 21, 1); ...
          repmat({'Obl_PLA'}, 21, 1); repmat({'Obl_TPU'}, 21, 1); repmat({'Obl_Rub'}, 21, 1)];

% Save the data to be loaded in Section G
save('PCA_Processed_Data.mat', 'PCA_features_bagging', 'labels');
fprintf('Processed PCA data saved for Bagging section.\n');

% Plot all three shapes
figure('Position', [100, 100, 1400, 400]);

% Cylinders
subplot(1,3,1)
scatter(scores_cyl_all(pla_indxs,1), scores_cyl_all(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_cyl_all(tpu_indxs,1), scores_cyl_all(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_cyl_all(rub_indxs,1), scores_cyl_all(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC1 (%.1f%%)', explained_cyl_all(1)), 'FontSize', 11);
ylabel(sprintf('PC2 (%.1f%%)', explained_cyl_all(2)), 'FontSize', 11);
title('Cylinders (All 9 papillae)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

% Hexagons
subplot(1,3,2)
scatter(scores_hex_all(pla_indxs,1), scores_hex_all(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_hex_all(tpu_indxs,1), scores_hex_all(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_hex_all(rub_indxs,1), scores_hex_all(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC1 (%.1f%%)', explained_hex_all(1)), 'FontSize', 11);
ylabel(sprintf('PC2 (%.1f%%)', explained_hex_all(2)), 'FontSize', 11);
title('Hexagons (All 9 papillae)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

% Oblongs
subplot(1,3,3)
scatter(scores_sq_all(pla_indxs,1), scores_sq_all(pla_indxs,2), ...
    100, color_pla, 'filled', 'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter(scores_sq_all(tpu_indxs,1), scores_sq_all(tpu_indxs,2), ...
    100, color_tpu, 'filled', 'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter(scores_sq_all(rub_indxs,1), scores_sq_all(rub_indxs,2), ...
    100, color_rub, 'filled', 'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel(sprintf('PC1 (%.1f%%)', explained_sq_all(1)), 'FontSize', 11);
ylabel(sprintf('PC2 (%.1f%%)', explained_sq_all(2)), 'FontSize', 11);
title('Oblongs (All 9 papillae)', 'FontSize', 12, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 9);
grid on;
axis equal;

sgtitle('2D PCA Projections Using All Sensors', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'B3a_All_Shapes_PCA_2D.fig');
saveas(gcf, 'B3a_All_Shapes_PCA_2D.png');


% B.3.b Scree plots for variance explained

figure('Position', [100, 100, 1200, 500]);

% Cylinders scree plot
subplot(1,3,1)
plot(1:length(explained_cyl_all), explained_cyl_all, 'bo-', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'b');
xlabel('Principal Component', 'FontSize', 11);
ylabel('Variance Explained (%)', 'FontSize', 11);
title('Scree Plot for Cylinders', 'FontSize', 12, 'FontWeight', 'bold');
grid on;
xlim([0 length(explained_cyl_all)+1]);

% Hexagons scree plot
subplot(1,3,2)
plot(1:length(explained_hex_all), explained_hex_all, 'ro-', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Principal Component', 'FontSize', 11);
ylabel('Variance Explained (%)', 'FontSize', 11);
title('Scree Plot for Hexagons', 'FontSize', 12, 'FontWeight', 'bold');
grid on;
xlim([0 length(explained_hex_all)+1]);

% Oblongs scree plot
subplot(1,3,3)
plot(1:length(explained_sq_all), explained_sq_all, 'go-', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'g');
xlabel('Principal Component', 'FontSize', 11);
ylabel('Variance Explained (%)', 'FontSize', 11);
title('Scree Plot for Oblongs', 'FontSize', 12, 'FontWeight', 'bold');
grid on;
xlim([0 length(explained_sq_all)+1]);

sgtitle('Variance Explained by Principal Components', 'FontSize', 14, 'FontWeight', 'bold');

saveas(gcf, 'B3b_Scree_Plots.fig');
saveas(gcf, 'B3b_Scree_Plots.png');
