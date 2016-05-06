//
//  HYFlightOrderListResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-26.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYFlightOrderListResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *orderList;

@end
