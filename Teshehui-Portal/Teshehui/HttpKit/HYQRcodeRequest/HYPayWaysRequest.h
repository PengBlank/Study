//
//  HYPayWaysRequest.h
//  Teshehui
//
//  Created by Kris on 15/5/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYPayWaysResponse.h"

@interface HYPayWaysRequest : CQBaseRequest

@property (nonatomic, copy) NSString *buyer_id;
@property (nonatomic, copy) NSString *voucher_code;

@end
