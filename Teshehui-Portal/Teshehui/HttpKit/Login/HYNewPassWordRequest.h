//
//  HYNewPassWordRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-5.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

/*
 * 设置新密码
 */

@interface HYNewPassWordRequest : CQBaseRequest

@property(nonatomic,copy)NSString* phone_mob;


@property(nonatomic,copy)NSString* phone_code;

@property(nonatomic,copy)NSString* newpassword;

@end
