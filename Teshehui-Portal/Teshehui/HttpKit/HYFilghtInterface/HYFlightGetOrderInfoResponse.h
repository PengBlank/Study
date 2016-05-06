//
//  HYFlightGetOrderInfoResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYFlightOrder.h"

@interface HYFlightGetOrderInfoResponse : CQBaseResponse

@property (nonatomic, strong, readonly) HYFlightOrder *flightOrder;

@end
