% Section D
% LDA

clear
close all

% D.1.a  Load the data required
square_TPU = load("PR_CW_mat/oblong_TPU_papillarray_single.mat");
square_rub = load("PR_CW_mat/oblong_rubber_papillarray_single.mat");

color_tpu = [1, 0, 0]; % Red for TPU [cite: 68]
color_rub = [0, 1, 0]; % Green for Rubber [cite: 68]

% Extract displacement data 13:15
tpu_disp = square_TPU.sensor_matrices_displacement(square_TPU.pks_locs, 13:15);
rub_disp = square_rub.sensor_matrices_displacement(square_rub.pks_locs, 13:15);

% Combine data and create labels
X = [tpu_disp; rub_disp];
n_tpu = size(tpu_disp, 1);
n_rub = size(rub_disp, 1);
labels = [repmat("TPU", n_tpu, 1); repmat("Rubber", n_rub, 1)];

% D.1.b Visualise tactile displacement with a FILLED 3D scatter plot [cite: 94]
figure('Name', 'D.1.b - 3D Displacement Scatter');
scatter3(tpu_disp(:,1), tpu_disp(:,2), tpu_disp(:,3), 80, color_tpu, 'filled', 'DisplayName', 'TPU');
hold on;
scatter3(rub_disp(:,1), rub_disp(:,2), rub_disp(:,3), 80, color_rub, 'filled', 'DisplayName', 'Rubber');
xlabel('D_X'); ylabel('D_Y'); zlabel('D_Z');
title('3D Displacement of Central Papilla (P4)');
legend('Location', 'best');
grid on; view(3);

% Save Figures 
saveas(gcf, 'D1b_Oblong_3D_Scatter.fig');
saveas(gcf, 'D1b_Oblong_3D_Scatter.png');

% D.1.c LDA to all 2D combinations (XY, XZ, YZ
pairs = {[1, 2], [1, 3], [2, 3]};
pair_names = {'DX vs DY', 'DX vs DZ', 'DY vs DZ'};
labels_xy = {{'D_X', 'D_Y'}, {'D_X', 'D_Z'}, {'D_Y', 'D_Z'}};

figure('Name', 'D.1.c - 2D LDA Combinations', 'Position', [100, 100, 1200, 400]);
for i = 1:3
    subplot(1, 3, i);
    current_data = X(:, pairs{i});
    
    % Fit LDA model
    mdl = fitcdiscr(current_data, labels);
    
    hold on;
    scatter(tpu_disp(:,pairs{i}(1)), tpu_disp(:,pairs{i}(2)), 40, color_tpu, 'filled', 'DisplayName', 'TPU');
    scatter(rub_disp(:,pairs{i}(1)), rub_disp(:,pairs{i}(2)), 40, color_rub, 'filled', 'DisplayName', 'Rubber');
    
    % Plot Decision Boundary
    K = mdl.Coeffs(1,2).Const;
    L = mdl.Coeffs(1,2).Linear;
    f = @(x1, x2) K + L(1)*x1 + L(2)*x2;
    h2 = ezplot(f, [min(current_data(:,1)) max(current_data(:,1)) min(current_data(:,2)) max(current_data(:,2))]);
    set(h2, 'Color', 'k', 'LineWidth', 2, 'DisplayName', 'Decision Boundary');
    
    title(pair_names{i});
    xlabel(labels_xy{i}{1}); ylabel(labels_xy{i}{2});
    grid on;
end
sgtitle('LDA Decision Boundaries for 2D Combinations');

% Save Figures 
saveas(gcf, 'D1c_LDA_2D_Combinations.fig');
saveas(gcf, 'D1c_LDA_2D_Combinations.png');

% D.1.d Apply LDA to the 3D data
mdl3D = fitcdiscr(X, labels);

% i. Reduce to 2 dimensions and re-plot
figure('Name', 'D.1.d.i - 3D LDA Projected');
W = mdl3D.Coeffs(1,2).Linear; 
projected_data = X * W; 

scatter(projected_data(1:n_tpu), X(1:n_tpu, 3), 60, color_tpu, 'filled', 'DisplayName', 'TPU');
hold on;
scatter(projected_data(n_tpu+1:end), X(n_tpu+1:end, 3), 60, color_rub, 'filled', 'DisplayName', 'Rubber');
xline(-mdl3D.Coeffs(1,2).Const / norm(W), '--k', 'LineWidth', 2, 'DisplayName', 'Discrimination Line');
xlabel('Linear Discriminant Score'); ylabel('D_Z (Original)');
title('Data Projected onto 3D LDA Discriminant');
legend('Location', 'best'); grid on;

saveas(gcf, 'D1di_LDA_Projected_2D.fig');
saveas(gcf, 'D1di_LDA_Projected_2D.png');

% ii. 3D plot with discrimination plane
figure('Name', 'D.1.d.ii - 3D LDA Discrimination Plane');
scatter3(tpu_disp(:,1), tpu_disp(:,2), tpu_disp(:,3), 60, color_tpu, 'filled');
hold on;
scatter3(rub_disp(:,1), rub_disp(:,2), rub_disp(:,3), 60, color_rub, 'filled');

% Create a grid for the plane
[gridX, gridY] = meshgrid(linspace(min(X(:,1)), max(X(:,1)), 10), ...
                          linspace(min(X(:,2)), max(X(:,2)), 10));
K3 = mdl3D.Coeffs(1,2).Const;
L3 = mdl3D.Coeffs(1,2).Linear;
gridZ = -(K3 + L3(1)*gridX + L3(2)*gridY) / L3(3);
surf(gridX, gridY, gridZ, 'FaceAlpha', 0.3, 'EdgeColor', 'none', 'FaceColor', 'k');

xlabel('D_X'); ylabel('D_Y'); zlabel('D_Z');
title('3D LDA Discrimination Plane');
legend('TPU', 'Rubber', 'Discrimination Plane');
grid on; view(3);

saveas(gcf, 'D1dii_LDA_Discrimination_Plane.fig');
saveas(gcf, 'D1dii_LDA_Discrimination_Plane.png');
