//
//  HYPassengerResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPassengers.h"

@interface HYPassengerResponse : CQBaseResponse

@property (nonatomic, strong) HYPassengers *passenger;
@property (nonatomic, copy) NSString *message;

@end
