clear all;
clc;
close all;
global pic
global transR transC
%read image
dirName='image\input1';
file = dir([dirName '\\' '*.jpg']);
fileSize = size(file, 1);

f = [488.527, 484.625, 478.562, 475.565, 475.712, 475.794, 479.168, 480.675, ...
    482.044, 484.327, 483.666, 482.215, 483.044, 484.608, 486.33, 488.642, 489.682]; %input1
% f = [474.987, 475.413, 477.654, 479.891, 482.052, 483.715, 486.347, 488.568, 490.652,...
%     492.343, 492.254, 492.762, 488.278, 479.833, 481.021, 481.321, 479.979, 472.517, 473.965];%input2
% f = [466.028, 468.751, 472.331, 474.654, 479.633, 483.561, 487.134, 489.893, 493.098, ... 
%     497.46, 500.987, 505.444, 504.743, 506.111, 498.641, 462.605, 463.006];%input3
img = {};
feature = {};
for i = 1:fileSize
    feature{i}.gray = [];
    feature{i}.cylin = [];
    img{i} = imread([dirName '\\' file(i).name]);
end

%feature detect & extract descriptor
for i = 1:fileSize
    feature{i}.gray = [];
    feature{i}.cylin = [];
    feature{i}.points = [];
    feature{i}.desc = [];
   
    pic.img = [];
    pic.gray = [];
    pic.points = [];
    pic.dectorValue = [];
    pic.orientCos = [];
    pic.orientSin = [];
    pic.patch = [];
    
    msop(img{i}, f(i));
    
    feature{i}.gray = pic.gray;
    feature{i}.cylin = pic.img;
    feature{i}.points = pic.points;
    feature{i}.desc = pic.patch;
end

bestmatch = {};
%feature matching & image matching
for i = 1:fileSize-1
    bestmatch{i}.match1 = [];
    bestmatch{i}.match2 = [];
    bestmatch{i}.trans = [];
    match_pair = featureMatching(feature{i}.desc, feature{i+1}.desc, feature{i}.points, feature{i+1}.points);
    %figure; showMatchedFeatures(feature{i}.gray, feature{i+1}.gray , match_pair{1}, match_pair{2},'montage');
    [dcol, drow, finalmatch1, finalmatch2] = ransac(match_pair{1}, match_pair{2});
    bestmatch{i}.match1 = finalmatch1;
    bestmatch{i}.match2 = finalmatch2;
    bestmatch{i}.trans = [floor(dcol) floor(drow)];
    figure; showMatchedFeatures(feature{i}.gray, feature{i+1}.gray , bestmatch{i}.match1, bestmatch{i}.match2,'montage');
end

%stitch
transR = 0;
transC = 0;
imout = feature{1}.cylin;
for i = 2:fileSize
    imout = blendImage(imout, feature{i}.cylin, bestmatch{i-1}.trans);
    %imout = imgStitch(imout , feature{i}.cylin , bestmatch{i-1}.trans(1), bestmatch{i-1}.trans(2));
end








% match_pair = featureMatching(feature{3}.desc, feature{4}.desc, feature{3}.points, feature{4}.points);
% index_pair = matchFeatures(feature{3}.desc, feature{4}.desc, 'MaxRatio', 0.6);
% 
% loc1 = pos1(index_pair(:,1), :);
% loc2 = pos2(index_pair(:,2), :);

% finalmatch1 = {};
% finalmatch2 = {};
% [dcol1, drow1, finalmatch1{1}, finalmatch1{2}] = ransac(match_pair{1}, match_pair{2});
% [dcol2, drow2, finalmatch2{1}, finalmatch2{2}] = ransac(loc1, loc2);
% trans1 = solverTranslation(bestmatch{1}.match1, bestmatch{1}.match2);
% trans2 = solverTranslation(finalmatch2{1}, finalmatch2{2});
% imout1 = blendImage(feature{3}.cylin , feature{4}.cylin , trans1);
% imout2 = blendImage(feature{3}.cylin , feature{4}.cylin , trans2);
% figure; showMatchedFeatures(feature{3}.gray, feature{4}.gray , finalmatch1{1}, finalmatch1{2},'montage');
% figure; showMatchedFeatures(feature{2}.gray, feature{3}.gray , finalmatch2{1}, finalmatch2{2},'montage');


