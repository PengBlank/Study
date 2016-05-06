//
//  HYUserInfoEditRequestParma.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 结算系统用户信息修改
 */

#import "HYBaseRequestParam.h" 
#import "HYHYUserInfoEditResponse.h"

@interface HYUserInfoEditRequestParma : HYBaseRequestParam

//必须字段
@property (nonatomic, copy) NSString *user_name;  //用户名
@property (nonatomic, copy) NSString *password;  //用户名密码，为空则不修改
@property (nonatomic, copy) NSString *im_qq;  //QQ
@property (nonatomic, copy) NSString *email;  //邮箱
@property (nonatomic, copy) NSString *real_name;  //真实姓名

//可选字段

@end
