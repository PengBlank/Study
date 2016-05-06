//
//  HYLoginV2RadioCell.h
//  Teshehui
//
//  Created by 成才 向 on 15/8/10.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYLoginV2RadioCell : HYBaseLineCell

@property (nonatomic, strong) UIButton *left;
@property (nonatomic, strong) UIButton *right;


//0 女 1男
@property (nonatomic, assign) HYUserInfoSex sex;

@property (nonatomic, copy) void (^didSelectSex)(HYUserInfoSex sex);


@end
