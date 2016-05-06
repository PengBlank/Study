//
//  HYLoginParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYLoginResponse.h"

@interface HYLoginParam : HYBaseRequestParam


//必须字段
@property (nonatomic, copy) NSString *user_name;  //用户名
@property (nonatomic, copy) NSString *password;  //密码


//可选字段

@end
