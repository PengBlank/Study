//
//  HYConfirmRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-9-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"
#import "HYConfirmResponse.h"

@interface HYConfirmRequest : CQBaseRequest

@property (nonatomic, copy) NSString *order_id;
@property (nonatomic, copy) NSString *order_code;

@end
