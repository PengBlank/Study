//
//  HYCoinAccountRequest.h
//  Teshehui
//
//  Created by Kris on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYCoinAccountRequest : CQBaseRequest

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger num_per_page;

@property (nonatomic, assign) NSInteger tradeType;   //1扣除，2增加
@property (nonatomic, assign) NSInteger acountType; //0现金券,1特火币

@end
