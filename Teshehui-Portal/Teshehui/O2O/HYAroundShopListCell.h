//
//  HYAroundShopListCell.h
//  Teshehui
//
//  Created by HYZB on 14-7-2.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@class HYQRCodeShop;

@interface HYAroundShopListCell : HYBaseLineCell

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *addrLabel;
@property (nonatomic, weak) UILabel *priceLabel;
@property (nonatomic, weak) UILabel *distanceLabel;
@property (nonatomic, weak) UILabel *onSaleTimeLabel;
@property (nonatomic, weak) UILabel *merchantCateLabel;
@property (nonatomic, weak) UIImageView *distanceIcon;
@property (nonatomic, weak) UIImageView *indicatorIcon;
@property (nonatomic, weak) UIImageView *photoView;

- (void)setWithShop:(HYQRCodeShop *)shop;

@end
