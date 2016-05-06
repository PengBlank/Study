//
//  HYPromotersCancelParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//


//取消操作员

#import "HYBaseRequestParam.h"
#import "HYPromotersCancelResponse.h"

@interface HYPromotersCancelParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *pid; //会员起始卡号
@property (nonatomic, copy) NSString *user_id;  //操作员会员ID
@property (nonatomic, copy) NSString *verify_code;  //验证码

@end

/*
 user_id	INT	操作员会员ID
 pid	INT	邀请码ID
 verify	INT	验证码
*/