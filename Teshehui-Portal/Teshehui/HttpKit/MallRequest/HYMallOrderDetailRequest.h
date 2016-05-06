//
//  HYMallOrderDetailRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-6-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallOrderDetailResponse.h"

@interface HYMallOrderDetailRequest : CQBaseRequest

//@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;

@end
