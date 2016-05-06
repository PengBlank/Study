//
//  HYAroundMallDetailCell.h
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@class HYQRCodeShop;
@interface HYAroundMallDetailCell : HYBaseLineCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

- (void)setWithShop:(HYQRCodeShop *)shopDetail;

@end
