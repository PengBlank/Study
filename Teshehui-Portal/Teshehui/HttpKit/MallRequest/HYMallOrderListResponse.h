//
//  HYMallOrderListResponse.h
//  Teshehui
//
//  Created by HYZB on 14-9-19.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallOrderDetail.h"

@interface HYMallOrderListResponse : CQBaseResponse

@property(nonatomic,strong) NSDictionary* pageInfo;
@property(nonatomic,strong) NSMutableArray* ordersArray;

@end
