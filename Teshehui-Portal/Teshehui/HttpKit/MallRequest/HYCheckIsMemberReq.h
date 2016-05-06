//
//  HYCheckIsMemberReq.h
//  Teshehui
//
//  Created by HYZB on 15/3/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYCheckIsMemberReq : CQBaseRequest

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *user_name;

@end

/*
 检查是否是有效用户----返回API列表索引
 A）API：check_is_member
 B)请求参数
 参数名称	参数类型	参数说明
 type	INT	类型，1：手机号  2：会员卡号  3：用户名
 user_name	STRING	手机号/会员卡号/用户名，如果是多个用;隔开
 C)正常返回
 参数名称	参数类型	参数说明
 status	INT	200
 data->msg	STRING	有效用户
 D)示例：http://www.teshehui.com/v2/api/red_packet/check_is_member
*/