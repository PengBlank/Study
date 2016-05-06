//
//  HYMallGetEvidencePictureCell.h
//  Teshehui
//
//  Created by Kris on 15/10/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
@class HYMallAfterSaleInfo;

@protocol HYMallGetEvidencePictureCellDelegate <NSObject>

@optional

- (void)getPicFromCamera;
- (void)getPicFromPhotoAlbum;
- (void)jumpToBrowserFromIndex:(NSInteger)index;

@end

@interface HYMallGetEvidencePictureCell : HYBaseLineCell

@property (nonatomic, strong) NSArray *picData;
@property (nonatomic, strong) NSArray *imgsUrlList;
@property (nonatomic, weak) id<HYMallGetEvidencePictureCellDelegate> delegate;

@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;

@end
