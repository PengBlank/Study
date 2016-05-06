//
//  HYPassengerListCell.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYPassengers.h"

@interface HYPassengerListCell : HYBaseLineCell

@property (nonatomic, strong) HYPassengers *passenger;
@property (nonatomic, strong) UIButton *eidtBtn;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, assign) BOOL showCheckBox;

@end
