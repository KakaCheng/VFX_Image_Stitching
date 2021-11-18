function match_pair = featureMatching(desc1, desc2, pos1, pos2)
match_pair = {};
kdtree1 = createns(desc1, 'nsmethod', 'kdtree');
kdtree2 = createns(desc2, 'nsmethod', 'kdtree');
 
[idx1, d1] = knnsearch(kdtree2, desc1, 'k', 2);%idx1: nn1&nn2 index of desc2(pos2)
[idx2, d2] = knnsearch(kdtree1, desc2, 'k', 2);%idx2: nn1&nn2 index of desc1(pos1)

% desc1 vs kdtree2
match1 = find(d1(:,1) < d1(:,2)*0.8);
match_idx1 = idx1(match1);

% desc2 vs kdtree1
match2 = find(d2(:,1) < d2(:,2)*0.8);
match_idx2 = idx2(match2);


bestmatch1 = [];
bestmatch2 = [];
for i = 1:length(match1)
    index = match_idx1(i);
    index2 = find(match2 == index);
    if(match_idx2(index2) == match1(i))
        bestmatch1 = [bestmatch1; match1(i)];
        bestmatch2 = [bestmatch2; match_idx1(i)];
    end
end

loc1 = pos1(bestmatch1, :);
loc2 = pos2(bestmatch2, :);
% loc1 = zeros(length(match1), 2);
% loc2 = zeros(length(match_idx1), 2);
% for i = 1:length(match1)
%     loc1(i,:) = pos1(match1(i),:);
%     loc2(i,:) = pos2(match_idx1(i),:);
% end
match_pair{1} = loc1;
match_pair{2} = loc2;
