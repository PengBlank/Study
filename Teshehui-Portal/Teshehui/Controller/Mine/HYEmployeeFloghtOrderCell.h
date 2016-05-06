//
//  HYEmployeeFloghtOrderCell.h
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"

@interface HYEmployeeFloghtOrderCell : HYBaseLineCell

@property (nonatomic, strong) UILabel *flightNameLabel;
@property (nonatomic, strong) UILabel *regionTimeLabel;
@property (nonatomic, strong) UILabel *passengerLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *completeBtn;

//
//- (void)setWithFlight:(id)flight;
@end
