function msop(image, f)
global pic


pic.img = [];
pic.gray = [];
pic.points = [];
pic.dectorValue = [];
pic.orientCos = [];
pic.orientSin = [];
pic.patch = [];


pic.img = cylindricalP(image, f);
% figure
% imshow(uint8(pic.img), []);
% hold on;
pic.gray = double(rgb2gray(uint8(pic.img)));
[row, col] = size(pic.gray);

% figure;
% imshow(pic.gray, []);
% hold on

rowFeature = [];
colFeature = [];
pointN = 2000;
pW = 20;
for(layer = 3:-1:1)
    [rowT, colT, valueT] = harris(imresize(pic.gray, 1/2^(3-layer)), 1.0, 100, 5+layer, layer);
    rowT = 2^(3-layer)*rowT;
    colT = 2^(3-layer)*colT;
    rowTt = [];
    colTt = [];
    value = [];
    
    orirow = [];
    oricol = [];
    
    for(cou = 1:length(rowT))
        
        if(rowT(cou) > pW*2^(3-layer+1) && rowT(cou) < col - pW*2^(3-layer+1) && colT(cou) > pW*2^(3-layer+1) && colT(cou) < row - pW*2^(3-layer+1))
            %plot?„é•·å¯?            
            temp_pw(1) = pic.gray(colT(cou)+pW*2^(3-layer), rowT(cou)+pW*2^(3-layer));
            temp_pw(2) = pic.gray(colT(cou)+pW*2^(3-layer), rowT(cou)-pW*2^(3-layer));
            temp_pw(3) = pic.gray(colT(cou)-pW*2^(3-layer), rowT(cou)+pW*2^(3-layer));
            temp_pw(4) = pic.gray(colT(cou)-pW*2^(3-layer), rowT(cou)-pW*2^(3-layer));
            
            if(sum(find(temp_pw == 0)) == 0)%?»æ?? ç‚ºprojection??”¢?Ÿç?coners
                
                rowTt = [rowTt; rowT(cou)];
                colTt = [colTt; colT(cou)];
                value = [value; valueT(cou) 2^(3-layer)];
                
                orirow = [orirow;rowT(cou)];%?«å???                
                oricol = [oricol;colT(cou)];
            end
        end
        
    end
    [costh, sinth] = orientation(imresize(pic.gray, 1/2^(3-layer)), orirow./2^(3-layer), oricol./2^(3-layer));
    
    tmpointN = pointN - length(rowTt);
    if(tmpointN < 0)
        
        for(cou1 = 1:pointN)
            rowFeature = [rowFeature; rowTt(cou1)];
            colFeature = [colFeature; colTt(cou1)];
            pic.dectorValue = [pic.dectorValue; value(cou1, :)];
            pic.orientCos = [pic.orientCos; costh(cou1)];
            pic.orientSin = [pic.orientSin; sinth(cou1)];
        end
        
    else
        rowFeature = [rowFeature; rowTt];
        colFeature = [colFeature; colTt];
        pic.dectorValue = [pic.dectorValue; value];
        pic.orientCos = [pic.orientCos; costh];
        pic.orientSin = [pic.orientSin; sinth];
    end
    
    
    
    
    pointN = tmpointN;
    if(pointN <= 0 )
        break;
    end
    
    
    
end
% plot(pic.rowFeature, pic.colFeature, 'r.');
% 
% quiver(pic.rowFeature, pic.colFeature, pic.orientCos, pic.orientSin);

g = fspecial('gaussian', 5.0, 2.0);
tgray = conv2(pic.gray, g, 'same');

for(cou = 1:length(rowFeature))
    
    pic.patch = [pic.patch; ...
        descriptor(rowFeature(cou), colFeature(cou), pic.dectorValue(cou, 2), pic.orientCos(cou), pic.orientSin(cou), tgray)];
    
end

pic.points = [rowFeature colFeature];

% for(cou = 1:length(pic.dectorValue))
%
% description(pic.rowFeature(cou), pic.colFeature(cou), pic.dectorValue(cou, 2), pic.orientCos(cou), pic.orientSin(cou));
%
% end


end