//
//  HYPayWaysResponse.h
//  Teshehui
//
//  Created by Kris on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "CQResponseResolve.h"

@interface HYPayWays : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_sn;
@property (nonatomic, copy) NSString *voucher_code;
@property (nonatomic, copy) NSString *voucher_name;
@property (nonatomic, copy) NSString *merchant_id;
@property (nonatomic, copy) NSString *merchant_name;
@property (nonatomic, copy) NSString *order_amount;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *buyer_id;
@property (nonatomic, copy) NSString *created;

@end

@interface HYPayWaysResponse : CQBaseResponse

@property (nonatomic, strong) HYPayWays *payWays;


@end
