% Assignment 5

% TODO: Make pictures of forest and test min 3 categories with own photos
% (kitchen, living room, forest)

folder = 'train';
num_clusters = 50;

disp('Building vocabulary ...');
C = BuildVocabulary(folder,num_clusters);

disp('Building KNN ...');
[training, group] = BuildKNN(folder, C);

disp('Classifying images ...');
conf_matrix = ClassifyImages('test',C,training,group);

disp('The Confusion Matrix:');
disp(conf_matrix);

disp(['Classified ', num2str(trace(conf_matrix)), ' of ', ...
      num2str(sum(sum(conf_matrix))), ' images correctly', ...
      ' (', num2str(trace(conf_matrix) / sum(sum(conf_matrix))*100), '%).'])
  
%%  
% Classify own images
% pictures of kitchen, living room and office

conv = ClassifyOwnImages('test_own/kitchen', C, training, group);
disp('Kitchen:');
disp(conf);
conv = ClassifyOwnImages('test_own/livingroom', C, training, group);
disp('Living room:');
disp(conf);
conv = ClassifyOwnImages('test_own/office', C, training, group);
disp('Office:');
disp(conf);
