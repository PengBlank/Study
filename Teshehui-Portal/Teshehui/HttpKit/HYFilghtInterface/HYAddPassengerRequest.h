//
//  HYAddPassengerRequest.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//


/**
 *添加常用旅客
 */
#import "CQBaseRequest.h"
#import "HYPassengerResponse.h"

@interface HYAddPassengerRequest : CQBaseRequest

//必须字段
@property (nonatomic, copy) NSString *realName;  //常用旅客姓名

//可选字段
@property (nonatomic, copy) NSString *certificateCode;  //证件类型ID
@property (nonatomic, copy) NSString *certifacateNumber;  //证件号码
@property (nonatomic, copy) NSString *sex;  //性别 M-男 F-女
@property (nonatomic, copy) NSString *is_adult;  //旅客类型 1-成人 2-儿童
@property (nonatomic, copy) NSString *phone;  //联系电话
@property (nonatomic, copy) NSString *country;  //国籍，格式：中国
@property (nonatomic, copy) NSString *birthday;  //生日，格式：1988-05-07
@property (nonatomic, copy) NSString *email;  //邮件

@end


/*
 参数名称	参数类型	参数说明
 user_id	INT	会员的ID不需要传递，登录会员可访问
 name	STRING	常用旅客姓名
 id_card_type_id	STRING	证件类型ID
 id_card_number	STRING	证件号码
 sex	STRING	性别 M-男 F-女
 is_adult	STRING	旅客类型 1-成人 2-儿童
 phone	STRING	联系电话
 country	STRING	国籍，格式：中国
 birthday	STRING	生日，格式：1988-05-07
 email	STRING	邮件
 */