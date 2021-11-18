function result = bounaryDelete(img)
img(:, 1, :) = [];
[row, col, height] = size(img);


for(up_b = 1:row)
    
    tmpR = img(up_b, :, 1);
    
    if(isempty(find(tmpR(:) == 0)))
        break;
    end
    
end


for(down_b = row:-1:up_b+1)
    
    tmpR = img(down_b, :, 1);
    
    if(isempty(find(tmpR(:) == 0)) )
        break;
    end
    
    
end

up_b
down_b
result = img(up_b:down_b, :,:);
figure;
imshow(uint8(result), []);


end