//
//  HYMallOrderDetailResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

#import "HYMallChildOrder.h"

@interface HYMallOrderDetailResponse : CQBaseResponse

@property (nonatomic, strong) HYMallChildOrder *orderDetail;

@end
