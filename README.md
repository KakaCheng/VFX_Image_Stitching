# VFX_Image_Stitching

## 設備
Nikon D7000, 鏡頭SIGMA24-70mm f2.8

## 演算法說明
**1. Image wrapping**
- 目的: 將圖像進行wrapping
- 演算法: **圓柱投影法(Cylindricalprojection)**
- 其他: 焦距的估算使用**autostitch軟體**

**2. Feature detection**  
- 目的: 找出角特徵點
- 演算法: **Multi-Sale Oriented Patches**
- 過程: 發現在第三層以後的特徵點數不多，所以我們僅縮小到原圖的1/2^3後即回傳所有特徵點。被篩選出的特徵點，計算出orientation的θ之後，以其為中心，向左右擴展各20個像素並旋轉θ角。\

**3. Feature matching**
- 目的: 找出兩張圖像的匹配點
- 演算法: kd-tree搭配knn search
- 過程: 第一張影像中所有的角特徵點作kd-tree，再用第二張影像中每一個角特徵點跟第一張影像得出的kd-tree作knn search，找出1-nn和2-nn，利用判斷條件: 1-nn < 2-nn\*0.8找出最佳match，把第一張影像和第二張影像對調重複上述動作，並判斷若影像一中的點a對應到點b，則影像二中點b應該也要對應到影像一中的點a，藉此找出兩張影像最終的match結果。

**4. Image matching**
- 目的: 排除異常值
- 演算法: ransac

**5. Stitching & blending**
- 目的: 拼接圖像
- 演算法: 線性內插
- 過程: 因為需要考慮兩張照片的相對位置來產生較大的矩陣，通常以左邊照片為基準點來移動右邊照片，此時會因dx及dy的正負而有四種組合，我們要先對這些組合來先產生出背景，然後再將兩張照片放到同一個背景裡頭，而後也依照dx及dy來找出重疊的部分並依照重疊大小來製作線性遮罩，靠近自身照片的權重會越大，反之則越小。而拼接後的影像會被放置為左邊的照片，如此使用遞回的概念即完成全景圖

**6. Results**

## 參考資料
1. M. Brown, D. G. Lowe, Recognising Panoramas, ICCV 2003
2. Matthew Brown, Richard Szeliski, Simon Winder, Multi-Image Matching using Multi-Scale Oriented Patches, CVPR 2005
3. AutoStitch :: a new dimension in automatic image stitching
