//
//  HYMallCancelOrderRequest.h
//  Teshehui
//
//  Created by HYZB on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYMallCancelOrderReponse.h"

@interface HYMallCancelOrderRequest : CQBaseRequest

//@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;
//@property (nonatomic, copy) NSString *cancel_reason;
//@property (nonatomic, copy) NSString *cancel_reason_code;

@end
