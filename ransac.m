function [dcol, drow, finalmatch1, finalmatch2] = ransac(match_pair1, match_pair2)
dcol = 0;
drow = 0;
finalmatch1 = [];
finalmatch2 = [];
n = 2;
p = 0.2;
P = 0.99;
k = ceil(log(1-P)/log(1-p^n));
threshold = 9;
nInliers = 0;
nFeatures = size(match_pair1, 1);

for i = 1:k
    pool = randperm(nFeatures);
    sample = pool(1:n);
    dx = sum(match_pair1(sample, 1)-match_pair2(sample, 1));
    dy = sum(match_pair1(sample, 2)-match_pair2(sample, 2));
    dx = dx/(-n);
    dy = dy/(-n);
    d = (match_pair1(:,1) + dx - match_pair2(:,1)).^2 + (match_pair1(:,2) + dy - match_pair2(:,2)).^2;
    d(sample) = 0;
    inlier = find(d < threshold);
    count = length(inlier);
    if(count > nInliers)
        nInliers = count;
        dcol = dx;
        drow = dy;
        finalmatch1 = match_pair1(inlier, :);
        finalmatch2 = match_pair2(inlier, :);
    end
end