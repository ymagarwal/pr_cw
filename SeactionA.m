% Section A
% Data Preparation and Visualisation

clear
close all

% Load all data files
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


% A.1.a Plot movement trajectories for cylinder and hexagon PLA objects
figure('Position', [100, 100, 1000, 800]);
sgtitle('End Effector Trajectories for PLA Objects', 'FontSize', 14, 'FontWeight', 'bold');
% Cylinder trajectory
subplot(2,1,1)
plot(cylinder_pla.end_effector_poses(:,1), cylinder_pla.end_effector_poses(:,2), ...
    'b-', 'LineWidth', 1.5, 'DisplayName', 'PLA Cylinder');
xlabel('X Position', 'FontSize', 11);
ylabel('Y Position', 'FontSize', 11);
title('Trajectory for Cylinder', 'FontSize', 12);
grid on;
legend('Location', 'best');
axis equal;

% Hexagon trajectory
subplot(2,1,2)
plot(hexagon_pla.end_effector_poses(:,1), hexagon_pla.end_effector_poses(:,2), ...
    'r-', 'LineWidth', 1.5, 'DisplayName', 'PLA Hexagon');
xlabel('X Position (m)', 'FontSize', 11);
ylabel('Y Position (m)', 'FontSize', 11);
title('Trajectory for Hexagon', 'FontSize', 12);
grid on;
legend('Location', 'best');
axis equal;
% Save figure
saveas(gcf, 'A1a_Trajectories.fig');
saveas(gcf, 'A1a_Trajectories.png');

% A.2 - Finding peaks and segmenting data

% Extract Z-force (normal force) - note the negative sign due to axis convention
% Find prominent peaks for all objects/materials
cylinder_pla.z_force = -cylinder_pla.ft_values(:,3);
[pks_cyl_pla, locs_cyl_pla] = findpeaks(cylinder_pla.z_force, 'MinPeakProminence', 3);
cylinder_pla.pks = pks_cyl_pla;
cylinder_pla.pks_locs = locs_cyl_pla;

hexagon_pla.z_force = -hexagon_pla.ft_values(:,3);
[pks_hex_pla, locs_hex_pla] = findpeaks(hexagon_pla.z_force, 'MinPeakProminence', 3);
hexagon_pla.pks = pks_hex_pla;
hexagon_pla.pks_locs = locs_hex_pla;

square_pla.z_force = -square_pla.ft_values(:,3);
[pks_sq_pla, locs_sq_pla] = findpeaks(square_pla.z_force, 'MinPeakProminence', 3);
square_pla.pks = pks_sq_pla;
square_pla.pks_locs = locs_sq_pla;

% TPU objects
cylinder_TPU.z_force = -cylinder_TPU.ft_values(:,3);
[pks_cyl_tpu, locs_cyl_tpu] = findpeaks(cylinder_TPU.z_force, 'MinPeakProminence', 3);
cylinder_TPU.pks = pks_cyl_tpu;
cylinder_TPU.pks_locs = locs_cyl_tpu;

hexagon_TPU.z_force = -hexagon_TPU.ft_values(:,3);
[pks_hex_tpu, locs_hex_tpu] = findpeaks(hexagon_TPU.z_force, 'MinPeakProminence', 3);
hexagon_TPU.pks = pks_hex_tpu;
hexagon_TPU.pks_locs = locs_hex_tpu;

square_TPU.z_force = -square_TPU.ft_values(:,3);
[pks_sq_tpu, locs_sq_tpu] = findpeaks(square_TPU.z_force, 'MinPeakProminence', 3);
square_TPU.pks = pks_sq_tpu;
square_TPU.pks_locs = locs_sq_tpu;

% Rubber objects
cylinder_rub.z_force = -cylinder_rub.ft_values(:,3);
[pks_cyl_rub, locs_cyl_rub] = findpeaks(cylinder_rub.z_force, 'MinPeakProminence', 3);
cylinder_rub.pks = pks_cyl_rub;
cylinder_rub.pks_locs = locs_cyl_rub;

hexagon_rub.z_force = -hexagon_rub.ft_values(:,3);
[pks_hex_rub, locs_hex_rub] = findpeaks(hexagon_rub.z_force, 'MinPeakProminence', 3);
hexagon_rub.pks = pks_hex_rub;
hexagon_rub.pks_locs = locs_hex_rub;

square_rub.z_force = -square_rub.ft_values(:,3);
[pks_sq_rub, locs_sq_rub] = findpeaks(square_rub.z_force, 'MinPeakProminence', 3);
square_rub.pks = pks_sq_rub;
square_rub.pks_locs = locs_sq_rub;

% A.2.a Plot peaks
figure('Position', [100, 100, 1200, 400]);
sgtitle('Normal Force Peaks PLA Objects', 'FontSize', 14, 'FontWeight', 'bold');

% Example 1: Cylinder PLA
subplot(1,3,1)
plot(cylinder_pla.z_force, 'b-', 'LineWidth', 1);
hold on;
plot(cylinder_pla.pks_locs, cylinder_pla.pks, 'rv', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Time', 'FontSize', 10);
ylabel('Normal Force', 'FontSize', 10);
title('Cylinder', 'FontSize', 11);
legend('Force', 'Peaks', 'Location', 'best');
grid on;

% Example 2: Hexagon PLA
subplot(1,3,2)
plot(hexagon_pla.z_force, 'b-', 'LineWidth', 1);
hold on;
plot(hexagon_pla.pks_locs, hexagon_pla.pks, 'rv', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Time', 'FontSize', 10);
ylabel('Normal Force', 'FontSize', 10);
title('Hexagon', 'FontSize', 11);
legend('Force', 'Peaks', 'Location', 'best');
grid on;

% Example 3: Oblong PLA
subplot(1,3,3)
plot(square_pla.z_force, 'b-', 'LineWidth', 1);
hold on;
plot(square_pla.pks_locs, square_pla.pks, 'rv', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
xlabel('Time', 'FontSize', 10);
ylabel('Normal Force', 'FontSize', 10);
title('Oblong', 'FontSize', 11);
legend('Force', 'Peaks', 'Location', 'best');
grid on;
view(2)

grid on;
saveas(gcf, 'A2a_Peaks.fig');
saveas(gcf, 'A2a_Peaks.png');

% A.3.a Scatter plots for middle papillae force data

% Middle papillae corresponds to columns 13:15 in sensor_matrices_force

% Extract force data for middle papillae at peak contact moments
pla_cyl = cylinder_pla.sensor_matrices_force(cylinder_pla.pks_locs, 13:15);
tpu_cyl = cylinder_TPU.sensor_matrices_force(cylinder_TPU.pks_locs, 13:15);
rub_cyl = cylinder_rub.sensor_matrices_force(cylinder_rub.pks_locs, 13:15);

pla_hex = hexagon_pla.sensor_matrices_force(hexagon_pla.pks_locs, 13:15);
tpu_hex = hexagon_TPU.sensor_matrices_force(hexagon_TPU.pks_locs, 13:15);
rub_hex = hexagon_rub.sensor_matrices_force(hexagon_rub.pks_locs, 13:15);

pla_sq = square_pla.sensor_matrices_force(square_pla.pks_locs, 13:15);
tpu_sq = square_TPU.sensor_matrices_force(square_TPU.pks_locs, 13:15);
rub_sq = square_rub.sensor_matrices_force(square_rub.pks_locs, 13:15);

% Define consistent colors for materials
color_pla = "blue";      % Blue for PLA
color_tpu = "red"; % Red/Orange for TPU
color_rub = "green"; % Green for Rubber

figure('Position', [100, 100, 800, 600]);
scatter3(pla_cyl(:,1), pla_cyl(:,2), pla_cyl(:,3), 80, color_pla, 'filled', ...
    'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter3(tpu_cyl(:,1), tpu_cyl(:,2), tpu_cyl(:,3), 80, color_tpu, 'filled', ...
    'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter3(rub_cyl(:,1), rub_cyl(:,2), rub_cyl(:,3), 80, color_rub, 'filled', ...
    'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('F_X', 'FontSize', 12);
ylabel('F_Y', 'FontSize', 12);
zlabel('F_Z', 'FontSize', 12);
title('Middle Papillae Force Cylinders', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
view(45, 30);
saveas(gcf, 'A3a_Cylinders_3D.fig');
saveas(gcf, 'A3a_Cylinders_3D.png');

figure('Position', [100, 100, 800, 600]);
scatter3(pla_hex(:,1), pla_hex(:,2), pla_hex(:,3), 80, color_pla, 'filled', ...
    'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter3(tpu_hex(:,1), tpu_hex(:,2), tpu_hex(:,3), 80, color_tpu, 'filled', ...
    'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter3(rub_hex(:,1), rub_hex(:,2), rub_hex(:,3), 80, color_rub, 'filled', ...
    'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('F_X', 'FontSize', 12);
ylabel('F_Y', 'FontSize', 12);
zlabel('F_Z', 'FontSize', 12);
title('Middle Papillae Force Hexagons', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
view(45, 30);
saveas(gcf, 'A3a_Hexagons_3D.fig');
saveas(gcf, 'A3a_Hexagons_3D.png');

figure('Position', [100, 100, 800, 600]);
scatter3(pla_sq(:,1), pla_sq(:,2), pla_sq(:,3), 80, color_pla, 'filled', ...
    'DisplayName', 'PLA', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
hold on;
scatter3(tpu_sq(:,1), tpu_sq(:,2), tpu_sq(:,3), 80, color_tpu, 'filled', ...
    'DisplayName', 'TPU', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
scatter3(rub_sq(:,1), rub_sq(:,2), rub_sq(:,3), 80, color_rub, 'filled', ...
    'DisplayName', 'Rubber', 'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
xlabel('F_X', 'FontSize', 12);
ylabel('F_Y', 'FontSize', 12);
zlabel('F_Z', 'FontSize', 12);
title('Middle Papillae Force - Oblongs', 'FontSize', 13, 'FontWeight', 'bold');
legend('Location', 'best', 'FontSize', 11);
grid on;
view(45, 30);
saveas(gcf, 'A3a_Oblongs_3D.fig');
saveas(gcf, 'A3a_Oblongs_3D.png');


% Save processed data with peaks and indices

save("PR_CW_mat/cylinder_papillarray_single.mat", "-struct", "cylinder_pla");
save("PR_CW_mat/hexagon_papillarray_single.mat", "-struct", "hexagon_pla");
save("PR_CW_mat/oblong_papillarray_single.mat", "-struct", "square_pla");

save("PR_CW_mat/cylinder_TPU_papillarray_single.mat", "-struct", "cylinder_TPU");
save("PR_CW_mat/hexagon_TPU_papillarray_single.mat", "-struct", "hexagon_TPU");
save("PR_CW_mat/oblong_TPU_papillarray_single.mat", "-struct", "square_TPU");

save("PR_CW_mat/cylinder_rubber_papillarray_single.mat", "-struct", "cylinder_rub");
save("PR_CW_mat/hexagon_rubber_papillarray_single.mat", "-struct", "hexagon_rub");
save("PR_CW_mat/oblong_rubber_papillarray_single.mat", "-struct", "square_rub");
