//
//  HYDeletePassengerRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 删除
 */
#import "CQBaseRequest.h"
#import "HYPassengerListResponse.h"

@interface HYDeletePassengerRequest : CQBaseRequest

@property (nonatomic, copy) NSString *user_id;  //会员的ID不需要传递，登录会员可访问
@property (nonatomic, copy) NSString *passenger_id;  //常用旅客的ID，多个用逗号分隔

@end
