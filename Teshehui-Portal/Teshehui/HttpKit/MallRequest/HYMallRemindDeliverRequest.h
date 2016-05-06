//
//  HYMallRemindDeliverRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

///提醒发货
#import "CQBaseRequest.h"
#import "HYMallRemindDeliverResponse.h"

@interface HYMallRemindDeliverRequest : CQBaseRequest

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;

@end
