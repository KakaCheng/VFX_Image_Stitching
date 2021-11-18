function pimg = cylindricalP(cimg, f)



[row, col, h] = size(cimg);

pimg = zeros(row, col, h);


cx = f.*atan( ([1:col]- col/2)./f );
cy = [];


for(cou = 1:col)
    
    cy = [cy, f*(([1:row] - row/2)')./(cx(cou)^2+f^2).^0.5];
    
end



for(x = 1:col)
    for(y = 1:row)
        
        pimg(round(cy(y, x)+row/2), round(cx(x) + col/2), :) = cimg(y, x, :);
        
        
    end
end

pimg(:, ceil(cx(end)+ col/2+1):end, :) = [];
pimg(:, 1:floor(cx(1)+ col/2-1), :) = [];




% figure
% imshow(uint8(pimg), []);
% hold on;
%798.273
end