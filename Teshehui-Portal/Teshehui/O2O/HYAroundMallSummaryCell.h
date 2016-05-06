//
//  HYAroundMallSummaryCell.h
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
@class HYQRCodeShop;

@protocol HYAroundMallSummaryCellDelegate <NSObject>
@optional
- (void)summaryCellDidClickPhoto;
- (void)summaryCellDidClickBigPhoto;

@end

@interface HYAroundMallSummaryCell : HYBaseLineCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) IBOutlet UILabel *photoCountLab;
@property (strong, nonatomic) IBOutlet UIImageView *bigPhotoView;
@property (strong, nonatomic) IBOutlet UIView *blackView1;
@property (strong, nonatomic) IBOutlet UIView *smallImgSuperView;

@property (nonatomic, weak) id<HYAroundMallSummaryCellDelegate> delegate;

- (void)setWithShopDetail:(HYQRCodeShop *)shop;

@end
