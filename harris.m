function [rowT, colT, value] = harris(im, sigma, thresh, radius, n)

if(n == 0)
    rowT = [];
    colT = [];
    return;
end

dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
dy = dx';

Ix = conv2(im, dx, 'same');    % Image derivatives
Iy = conv2(im, dy, 'same');

% if(n == 3)
%     close all;
%     figure
% imshow((Ix.^2+Iy.^2).^0.5, []);
% hold on
% end


g = fspecial('gaussian', 15.0, sigma);


% Compute products of derivatives at every pixel
% Compute the sums of the products of derivatives at each pixel

%Hessian martix
sx2 = conv2(Ix.^2, g, 'same'); 
sy2 = conv2(Iy.^2, g, 'same');
sxy = conv2(Ix.*Iy, g, 'same');


R = (sx2.*sy2 - sxy.^2)./(sx2 + sy2 + eps);
tmpR = R;
sze = 2*radius+1;                   % Size of mask.
mx = ordfilt2(R,sze^2,ones(sze)); 

[colT, rowT] = find(R == mx & R >= thresh);


value = [];
for(cou = 1:length(colT))
value = [value;tmpR(colT(cou), rowT(cou))];
end

result = flipud(sortrows([colT, rowT, value], 3));

colT = result(:,1)*2^(3-n);
rowT = result(:,2)*2^(3-n);
value = result(:,3);

return;

end

% function [rowT, colT, R] = harris(im, sigma, thresh, radius)
% 
% dx = [-1 0 1; -1 0 1; -1 0 1]; % Derivative masks
% dy = dx';
% 
% Ix = conv2(im, dx, 'same');    % Image derivatives
% Iy = conv2(im, dy, 'same');
% 
% % Generate Gaussian filter of size 6*sigma (+/- 3sigma) and of
% % minimum size 1x1.
% g = fspecial('gaussian', max(1,fix(6*sigma)), sigma);
% 
% % Compute products of derivatives at every pixel
% % Compute the sums of the products of derivatives at each pixel
% sx2 = conv2(Ix.^2, g, 'same'); 
% sy2 = conv2(Iy.^2, g, 'same');
% sxy = conv2(Ix.*Iy, g, 'same');
% 
% [row, col] = size(sx2);
% R = size(row, col);
% % k = 0.06;
% % R = (sx2.*sy2 - sxy.^2) - k*(sx2 + sy2).^2;
% R = (sx2.*sy2 - sxy.^2)./(sx2 + sy2 + eps);
% 
% sze = 2*radius+1;                   % Size of mask.
% mx = ordfilt2(R,sze^2,ones(sze)); 
% 
% % figure;imshow(uint8(mx), []);
% [colT, rowT] = find(R == mx & R>=thresh);
% 
% % figure;
% % imshow(uint8(im), []); 
% % axis image;
% % colormap(gray);
% % hold on;
% % plot(rowT, colT,'rs'), title('corners detected');
% 
% 
% end