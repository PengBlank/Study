//
//  HYForGetRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 *发送忘记密码的请求
 */

#import "CQBaseRequest.h"

@interface HYForGetRequest : CQBaseRequest

@property (nonatomic, copy) NSString *phone_mob;

@end
