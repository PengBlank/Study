//
//  HYFlowerPay_3_Cell.h
//  Teshehui
//
//  Created by ichina on 14-2-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseLineCell.h"
#import "HYFlowerOrderInfo.h"

@interface HYFlowerPay_3_Cell : HYBaseLineCell

@property (nonatomic,retain)UILabel* nameLab;

-(void)setList:(HYFlowerOrderInfo*)OrderInfo;
@end
