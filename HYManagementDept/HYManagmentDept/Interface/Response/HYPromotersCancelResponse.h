//
//  HYPromotersCancelResponse.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//取消操作员

#import "HYBaseResponse.h"

@interface HYPromotersCancelResponse : HYBaseResponse

@end

/*
 data	OBJECT	10003:缺少参数
 10018：该操作员出现异常或者不存在
 10005：操作失败
 200:操作成功
 10021:请发送验证码通知中心
 10022:验证码已过期
 10023:连续3次输入验证码错误
 （注：提示这个错误的时候需退出用户登录）
 10024:验证码错误
*/