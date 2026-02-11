% Section E 
% Clustering
clear
close all


%% Load data
pla_data = load("PR_CW_mat/oblong_papillarray_single.mat");
tpu_data = load("PR_CW_mat/oblong_TPU_papillarray_single.mat");
rub_data = load("PR_CW_mat/oblong_rubber_papillarray_single.mat");

color_tpu = [1, 0, 0]; % Red for TPU
color_rub = [0, 1, 0]; % Green for Rubber
color_pla = [0, 0, 1];

% Extract force
PLA = pla_data.sensor_matrices_force(pla_data.pks_locs,10:12);
TPU = tpu_data.sensor_matrices_force(tpu_data.pks_locs,10:12);
RUB = rub_data.sensor_matrices_force(rub_data.pks_locs,10:12);

X = [PLA; TPU; RUB];

nPLA = 21;
nTPU = 21;

% E.1.a Ground truth scatter plot
figure
scatter3(PLA(:,1),PLA(:,2),PLA(:,3),60,color_pla,'filled'); hold on
scatter3(TPU(:,1),TPU(:,2),TPU(:,3),60,color_tpu,'filled')
scatter3(RUB(:,1),RUB(:,2),RUB(:,3),60,color_rub,'filled')

xlabel('F_x')
ylabel('F_y')
zlabel('F_z')
title('Oblong Objects Force Data')
legend('PLA','TPU','Rubber','Location','best')
grid on
view(40,30)

saveas(gcf,'E1a_GroundTruth.png')

%% ---------------------------------------------------------
%% E.1.b K-means clustering (Euclidean distance)
rng(42)
[idx_euc, C_euc] = kmeans(X,3,'Distance','sqeuclidean');

markers = {'o','s','^'};

figure
hold on
for k = 1:3
    scatter3(X(idx_euc==k,1), ...
             X(idx_euc==k,2), ...
             X(idx_euc==k,3), ...
             70,'k',markers{k},'LineWidth',1.5)
end

% Overlay material colours lightly
scatter3(PLA(:,1),PLA(:,2),PLA(:,3),30,color_pla,'filled','MarkerFaceAlpha',0.3)
scatter3(TPU(:,1),TPU(:,2),TPU(:,3),30,color_tpu,'filled','MarkerFaceAlpha',0.3)
scatter3(RUB(:,1),RUB(:,2),RUB(:,3),30,color_rub,'filled','MarkerFaceAlpha',0.3)

scatter3(C_euc(:,1), C_euc(:,2), C_euc(:,3), ...
    220, 'k', 'p', 'filled', 'MarkerEdgeColor','w', 'LineWidth',1.5);

xlabel('F_x')
ylabel('F_y')
zlabel('F_z')
title('K-means Clustering (Euclidean Distance)')
legend('Cluster 1','Cluster 2','Cluster 3','Location','best')
grid on
view(40,30)

saveas(gcf,'E1b_Kmeans_Euclidean.png')

%% ---------------------------------------------------------
%% E.1.c K-means clustering (Cityblock distance)
rng(1)
[idx_city, C_city] = kmeans(X,3,'Distance','cityblock');

figure
hold on
for k = 1:3
    scatter3(X(idx_city==k,1), ...
             X(idx_city==k,2), ...
             X(idx_city==k,3), ...
             70,'k',markers{k},'LineWidth',1.5)
end

scatter3(PLA(:,1),PLA(:,2),PLA(:,3),30,color_pla,'filled','MarkerFaceAlpha',0.3)
scatter3(TPU(:,1),TPU(:,2),TPU(:,3),30,color_tpu,'filled','MarkerFaceAlpha',0.3)
scatter3(RUB(:,1),RUB(:,2),RUB(:,3),30,color_rub,'filled','MarkerFaceAlpha',0.3)

scatter3(C_city(:,1), C_city(:,2), C_city(:,3), ...
    220, 'k', 'p', 'filled', 'MarkerEdgeColor','w', 'LineWidth',1.5);
xlabel('F_x')
ylabel('F_y')
zlabel('F_z')
title('K-means Clustering (Cityblock Distance)')
legend('Cluster 1','Cluster 2','Cluster 3','Location','best')
grid on
view(40,30)

saveas(gcf,'E1c_Kmeans_Cityblock.png')

