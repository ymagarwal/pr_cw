% Section G 
% Bagging

clear; 
close all;

% G.1.a Load PCA-processed data and Setup
% Loading the file saved at the end of Section B
load('PCA_Processed_Data.mat'); 

% X contains the PCA scores (features)
% labels contains the ground truth (classes)
X = PCA_features_bagging; 
Y = categorical(labels); % Convert to categorical for classification

% Specify the number of bags/trees
numTrees = 100; 
rng(42); % For reproducibility

% Train Bagged Decision Trees
% Using TreeBagger for bootstrap aggregation
bagModel = TreeBagger(numTrees, X, Y, ...
    'Method', 'classification', ...
    'OOBPrediction', 'on', ...
    'OOBPredictorImportance', 'on');

fprintf('Bagging model trained with %d trees.\n', numTrees);

%% G.1.b Visualise two generated decision trees
% Visualizing the first two trees in the ensemble 

% Tree 1
figure('Name', 'Decision Tree 1');
view(bagModel.Trees{1}, 'Mode', 'graph');
title('Bagged Decision Tree #1');

% Tree 2
figure('Name', 'Decision Tree 2');
view(bagModel.Trees{2}, 'Mode', 'graph');
title('Bagged Decision Tree #2');

%% G.1.c Confusion Matrix and Accuracy
% Use OOB (Out-of-Bag) predictions to simulate test data performance 
oobPred = oobPredict(bagModel);
oobPred = categorical(oobPred);

figure('Position', [100, 100, 700, 600]);
confusionchart(Y, oobPred);
title('Confusion Matrix: Bagging (OOB Data)');

% Calculate overall accuracy
correctPredictions = sum(oobPred == Y);
totalPredictions = length(Y);
accuracy = (correctPredictions / totalPredictions) * 100;
fprintf('Overall OOB Accuracy: %.2f%%\n', accuracy);

%% Error Analysis
figure;
plot(oobError(bagModel), 'LineWidth', 2);
xlabel('Number of Trees');
ylabel('Out-of-Bag Classification Error');
title('OOB Error Rate vs. Ensemble Size');
grid on;