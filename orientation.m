function [costh, sinth] = orientation(img, row, col)

dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dy = dx';

Ix = conv2(img, dx, 'same');    % Image derivatives
Iy = conv2(img, dy, 'same');


%orientation assignment
g = fspecial('gaussian', 3.0, 4.5);
gIx = conv2(Ix, g, 'same');
gIy = conv2(Iy, g, 'same');

absu = (gIx.^2.0+gIy.^2.0).^0.5;

costh = [];
sinth = [];
for(x = 1:length(row))
    costh = [costh; gIx(col(x), row(x))/(absu(col(x), row(x))+eps)];%使用在影像裡，row與col必須對換
    sinth = [sinth; gIy(col(x), row(x))/(absu(col(x), row(x))+eps)];
end

return;
end