//
//  HYFlowerPay_1_Cell.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerOrderInfo.h"

@interface HYFlowerPay_1_Cell : HYBaseLineCell

@property (nonatomic,retain)UILabel* ddbhLab;

@property (nonatomic,retain)UILabel* xdsjLab;

@property (nonatomic,retain)UILabel* shrLab;

@property (nonatomic,retain)UILabel* sjLab;

@property (nonatomic,retain)UILabel* shdzLab;

-(void)setList:(HYFlowerOrderInfo*)OrderInfo;
@end
