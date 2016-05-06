//
//  HYGetPaymentTypeRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 获取支持的支付方式接口
 */

#import "HYBaseRequestParam.h"
#import "HYGetPaymentTypeResponse.h"

@interface HYGetPaymentTypeRequest : HYBaseRequestParam

@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_type;

@end
