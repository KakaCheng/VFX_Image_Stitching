function patch = descriptor(row, col, n, oCos, oSin, img)
Dx = [];
Dy = [];
halfPW = 20;

wpos = zeros(4, 2);

wpos(1, :) = [row+halfPW*n, col+halfPW*n];
wpos(2, :) = [row+halfPW*n, col-(halfPW-1)*n];
wpos(3, :) = [row-(halfPW-1)*n, col-(halfPW-1)*n];
wpos(4, :) = [row-(halfPW-1)*n, col+halfPW*n];
%1->4->3->2
pointx = [];
pointy = [];

vector14 = [];
vector43 = [];

for(cou = 1:4)
    
    wpos(cou,:) = wpos(cou,:) - [row, col];
    wpos(cou,:) = ([oCos, -oSin; oSin, oCos]*wpos(cou, :)')';
    wpos(cou,:) = wpos(cou,:) + [row, col];
    
end
tv14 = (wpos(2,:) - wpos(1,:))./7;
tv43 = (wpos(3,:) - wpos(2,:))./7;

d = [0:7]';
vector14 = [d.*tv14(1), d.*tv14(2)];
vector43 = [d.*tv43(1), d.*tv43(2)];

m = [wpos(1,:);wpos(1,:);wpos(1,:);wpos(1,:);wpos(1,:);wpos(1,:);wpos(1,:);wpos(1,:)];


pointx = m + vector14;

Dx = pointx(:,1)+vector43(:,1);
Dy = pointx(:,2)+vector43(:,2);





% for(cou = 1:3)
%     plot([wpos(cou, 1), wpos(cou+1, 1)], [wpos(cou, 2), wpos(cou+1, 2)], 'y-');
% end
% plot([wpos(4, 1), wpos(1, 1)], [wpos(4, 2), wpos(1, 2)], 'y-');


%plot(round(Dx(:)), round(Dy(:)), 'g.');


patch = img(round(Dy(:)), round(Dx(:)));
patch = patch(:)';


%Normalize
pmean = mean(patch);
pstd = std(patch);
patch = (patch-pmean)/pstd;

end