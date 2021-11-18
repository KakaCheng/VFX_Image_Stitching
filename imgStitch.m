function result = imgStitch(imgL, imgR, dx, dy)

global transR transC

dx = transC+dx;
dy = transR+dy;

[rL, cL, hL] = size(imgL);
[rR, cR, hR] = size(imgR);

if(dx >= 0)
    
    if(cR + abs(dx) <= cL)
        
        n = cL;
        
        mask_psc = abs(dx)+1:cR;
        
    else
        
        n = cR + abs(dx);
        
        mask_psc = abs(dx)+1:cL;
        
    end
    
    mask_cR = [0:1/(length(mask_psc)-1):1];
    mask_cL = [1:-1/(length(mask_psc)-1):0];
    
else
    
    if(cL + abs(dx) <= cR)
        n = cR;
        
        mask_psc = abs(dx)+1:cL;
    else
        n = cL + abs(dx);
        
        mask_psc = abs(dx)+1:cR;
        
    end
    
    mask_cR = [1:-1/(length(mask_psc)-1):0];
    mask_cL = [0:1/(length(mask_psc)-1):1];
    
end




if(dy >= 0)
    ffix = 'R';
    if(rL + abs(dy) <= rR)
        m = rR;
        
        mask_psr = abs(dy)+1:rL;
    else
        m = rL+abs(dy);
        
        mask_psr = abs(dy)+1:rR;
        
        
    end
    
    mask_rR = [0:1/(length(mask_psr)-1):1]';
    mask_rL = [1:-1/(length(mask_psr)-1):0]';
else
    ffix = 'L';
    if(rR + abs(dy) <= rL)
        m = rL;
        
        mask_psr = abs(dy)+1:rR;
    else
        m = rR + abs(dy);
        
        mask_psr = abs(dy)+1:rL;
    end
    
    mask_rR = [1:-1/(length(mask_psr)-1):0]';
    mask_rL = [0:1/(length(mask_psr)-1):1]';
    
end

%
result = zeros(m, n, 3);

maskR = [];
maskL = [];

for(cou = 1:length(mask_rR))
    
    maskR = [maskR; mask_cR];
    maskL = [maskL; mask_cL];
end

% for(cou = 1:length(mask_cL))
%     
%     maskR(:, cou) = (maskR(:, cou) + mask_rR)./2;
%     maskL(:, cou) = (maskL(:, cou) + mask_rL)./2;
%     
% end


if(ffix == 'L') %dy < 0
    
    
    
    patchR = imgR(1:size(maskR, 1), 1:size(maskR, 2), :);
    
    patchL = imgL(abs(dy)+1:abs(dy)+size(maskL, 1) ...
        , abs(dx)+1:abs(dx)+size(maskL,2), :);
    
    
    tmpimgL = patchL(:,:,1);
    tmpimgR = patchR(:,:,1);
    
    tmp_posL = find(tmpimgL == 0);
    tmp_posR = find(tmpimgR == 0);
    
    maskR(tmp_posL) = 1;
    maskL(tmp_posR) = 1;
    
    tpR = patchR;
    tpL = patchL;
    
    for(cou = 1:3)
        patchR(:,:,cou) = tpR(:,:,cou).*maskR;
        patchL(:,:,cou) = tpL(:,:,cou).*maskL;
    end
    
    
    
    
    
    imgR(1:size(maskR, 1), 1:size(maskR, 2), :) = patchR;
    imgL(abs(dy)+1:abs(dy)+size(maskL, 1) ...
        , abs(dx)+1:abs(dx)+size(maskL,2), :) = patchL;
    
    
    result(1:rL, 1:cL, :) = imgL;
    result(abs(dy)+1:abs(dy)+rR, abs(dx)+1:abs(dx)+cR, :) ...
        = result(abs(dy)+1:abs(dy)+rR, abs(dx)+1:abs(dx)+cR, :)+imgR;
    
    
    
    transR = transR + dy;
    transC = transC + dx;
    
    
else%dy >= 0
    
    patchR = imgR(abs(dy)+1:end, 1:size(maskR, 2), :);
    patchL = imgL(1:size(maskL, 1), abs(dx)+1:abs(dx)+size(maskL, 2), :);
    
    tmpimgL = patchL(:,:,1);
    tmpimgR = patchR(:,:,1);
    
    tmp_posL = find(tmpimgL == 0);
    tmp_posR = find(tmpimgR == 0);
    
    maskR(tmp_posL) = 1;
    maskL(tmp_posR) = 1;
    
    tpR = patchR;
    tpL = patchL;
    
    for(cou = 1:3)
        patchR(:,:,cou) = tpR(:,:,cou).*maskR;
        patchL(:,:,cou) = tpL(:,:,cou).*maskL;
    end
    
    
    
    
    imgR(abs(dy)+1:abs(dy)+size(maskR, 1), 1:size(maskR, 2), :) = patchR;
    imgL(1:size(maskL, 1), abs(dx)+1:abs(dx)+size(maskL, 2), :) = patchL;
    
    
    result(1:rR, abs(dx)+1:end, :) = imgR;
    result(abs(dy)+1:abs(dy)+rL, 1:cL, :) = (result(abs(dy)+1:abs(dy)+rL, 1:cL, :)+imgL);
    
    
    
    transR = transR +dy;
    transC = transC + dx;
    
end

figure;
imshow(uint8(result), []);
end