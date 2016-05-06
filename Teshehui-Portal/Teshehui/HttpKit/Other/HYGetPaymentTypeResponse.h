//
//  HYGetPaymentTypeResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-12.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYGetPaymentTypeResponse : CQBaseResponse

@property (nonatomic, strong, readonly) NSArray *payTypes;

@end
