//
//  BusinesslistCell.h
//  Teshehui
//
//  Created by apple_administrator on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"

@class BusinessListInfo;
@interface BusinesslistCell : BaseCell

@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UILabel        *distanceLabel;
@property (nonatomic,strong) UILabel        *categoryLabel;
@property (nonatomic,strong) UIButton       *rightButton;

@property (nonatomic,strong) UIImageView    *imageV;

@property (nonatomic,strong) UIImageView    *addressImageV;

- (void)setWithShop:(BusinessListInfo *)shop;

@end
