//
//  HYEmployee.h
//  Teshehui
//
//  Created by HYZB on 14-7-16.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYEmployee : NSObject

@property (nonatomic, copy) NSString *user_id;  //用户ID
@property (nonatomic, copy) NSString *number;  //会员卡号
@property (nonatomic, copy) NSString *real_name;  //真实姓名
@property (nonatomic, copy) NSString *phone_mob;  //手机号码
@property (nonatomic, copy) NSString *policy_end;  //保险截止日期，如：2014-07-15

- (id)initWithData:(NSDictionary *)data;

@end
