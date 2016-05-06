//
//  HYFlowerOrderListResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYFlowerOrderSummary.h"

@interface HYFlowerOrderListResponse : CQBaseResponse

@property (nonatomic, strong) NSMutableArray *orderList;

@end
