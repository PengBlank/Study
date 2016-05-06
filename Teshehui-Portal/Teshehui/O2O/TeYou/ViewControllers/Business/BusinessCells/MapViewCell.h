//
//  MapViewCell.h
//  Teshehui
//
//  Created by apple_administrator on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BaseCell.h"
@class BusinessListInfo;
@interface MapViewCell : BaseCell
@property (nonatomic,strong) UILabel        *nameLabel;
@property (nonatomic,strong) UILabel        *desLabel;
@property (nonatomic,strong) UILabel        *distanceLabel;
@property (nonatomic,strong) UILabel        *categoryLabel;
@property (nonatomic,strong) UIButton       *rightButton;

@property (nonatomic,strong) UIImageView    *imageV;

@property (nonatomic,strong) UIImageView    *addressImageV;

- (void)setWithShopToMapView:(BusinessListInfo *)shop;
@end
