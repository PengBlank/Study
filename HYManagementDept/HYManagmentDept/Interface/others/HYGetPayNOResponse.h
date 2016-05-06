//
//  HYGetPayNOResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseResponse.h"
#import "WXApiObject.h"

@interface HYGetPayNOResponse : HYBaseResponse

@property (nonatomic, copy, readonly) NSString *payNO;
@property (nonatomic, copy, readonly) NSString *order_cash;
@property (nonatomic, copy, readonly) NSString *order_amount;
@property (nonatomic, copy, readonly) NSString *call_back_url;
@property (nonatomic, strong, readonly) PayReq *wxPayInfo;

@end
