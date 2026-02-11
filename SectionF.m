% Section F 
% Gaussian Mixture Model

clear
close all

% Load cylinder displacement data

PLA = load("PR_CW_mat/cylinder_papillarray_single.mat");
TPU = load("PR_CW_mat/cylinder_TPU_papillarray_single.mat");
RUB = load("PR_CW_mat/cylinder_rubber_papillarray_single.mat");

% Central papilla displacement (P4 → columns 10:12)
pla = PLA.sensor_matrices_displacement(PLA.pks_locs,10:12);
tpu = TPU.sensor_matrices_displacement(TPU.pks_locs,10:12);
rub = RUB.sensor_matrices_displacement(RUB.pks_locs,10:12);

% Use Dy and Dz
X = [pla; tpu; rub];
X2 = X(:,[2 3]);

idxPLA = 1:21;
idxTPU = 22:42;
idxRUB = 43:63;


color_tpu = [1, 0, 0]; % Red for TPU 
color_rub = [0, 1, 0]; % Green for Rubber 
color_pla = [0, 0, 1]; % Glue for PLA

% F.1.a 2D scatter (ground truth)

figure
scatter(X2(idxPLA,1),X2(idxPLA,2),60,color_pla,'filled'); hold on
scatter(X2(idxTPU,1),X2(idxTPU,2),60,color_tpu,'filled')
scatter(X2(idxRUB,1),X2(idxRUB,2),60,color_rub,'filled')

xlabel('D_y')
ylabel('D_z')
title('Cylinder Objects – Displacement (Central Papilla)')
legend('PLA','TPU','Rubber','Location','best')
grid on

saveas(gcf,'F1a_Displacement_Scatter.png')

% F.1.b – Fit GMM and plot contour

rng(1)
GM = fitgmdist(X2,3);

figure
scatter(X2(idxPLA,1),X2(idxPLA,2),40,color_pla,'filled'); hold on
scatter(X2(idxTPU,1),X2(idxTPU,2),40,color_tpu,'filled')
scatter(X2(idxRUB,1),X2(idxRUB,2),40,color_rub,'filled')

gmPDF = @(x,y) arrayfun(@(x0,y0) pdf(GM,[x0 y0]),x,y);
fcontour(gmPDF,[min(X2(:,1)) max(X2(:,1)) min(X2(:,2)) max(X2(:,2))], ...
         'LineWidth',1.2,'LevelStep',0.5)

xlabel('D_y')
ylabel('D_z')
title('GMM Contours over Displacement Data')
grid on

saveas(gcf,'F1b_GMM_Contours.png')

% F.1.c  3D surface plot

figure
fsurf(gmPDF, ...
      [min(X2(:,1)) max(X2(:,1)) min(X2(:,2)) max(X2(:,2))], ...
      'MeshDensity',40)

xlabel('D_y')
ylabel('D_z')
zlabel('Probability Density')
title('GMM Probability Density Surface')
view(45,30)
camlight
lighting gouraud
colorbar

saveas(gcf,'F1c_GMM_Surface.png')

% F.1.d – Hard cluster assignment

clusters = cluster(GM,X2);
markers = {'o','s','^'};

figure
hold on
for k = 1:3
    scatter(X2(clusters==k,1),X2(clusters==k,2), ...
        70,'k',markers{k},'LineWidth',1.5)
end

xlabel('D_y')
ylabel('D_z')
title('GMM Hard Cluster Assignments')
legend('Component 1','Component 2','Component 3','Location','best')
grid on

saveas(gcf,'F1d_GMM_Clusters.png')

set(0,'DefaultFigureVisible','on');
