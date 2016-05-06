//
//  HYPassengerListResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-28.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYPassengers.h"

@interface HYPassengerListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *passengerList;

@end
