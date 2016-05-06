//
//  HYPromotersVerifyCodeRequest.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-10-1.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYPromotersVerifyCodeResponse.h"

/**
 *  发送短信验证码
 */
@interface HYPromotersVerifyCodeRequest : HYBaseRequestParam

@property (nonatomic, strong) NSString *pid;    //邀请码
@property (nonatomic, strong) NSString *user_id;    //会员id
@property (nonatomic, strong) NSString *number; //会员卡号？

@end
