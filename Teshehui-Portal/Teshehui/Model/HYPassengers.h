//
//  HYPassengers.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-27.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"
#import "HYCardType.h"

typedef enum _PassengerAgeType
{
    Adult = 0,
    Children,
    Baby,
    Undefined   //默认的
}PassengerAgeType;

@interface HYPassengers : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cardID;
@property (nonatomic, copy) NSString *passengerId	;//STRING	常用旅客ID;
@property (nonatomic, copy) NSString *id_card_type_id;  //证件类型ID
@property (nonatomic, copy) NSString *cardName;  //证件的名称

@property (nonatomic, copy) NSString *sex;  //性别 M-男 F-女
@property (nonatomic, copy) NSString *is_adult;  //旅客类型 1-成人 2-儿童
@property (nonatomic, copy) NSString *phone;  //联系电话
@property (nonatomic, copy) NSString *country;  //国籍，格式：中国
@property (nonatomic, copy) NSString *birthday;  //生日，格式：1988-05-07
@property (nonatomic, copy) NSString *email;  //邮件

@property (nonatomic, copy) NSString *ticketNO;  //机票票号，只有在机票预订成功出票之后才有该值 

@property (nonatomic, assign) PassengerAgeType type;

@property (nonatomic, assign) BOOL isSelected;  //在界面选择的时候使用该参数

@property (nonatomic, assign) BOOL isChildren;  //是否购买儿童票
@property (nonatomic, assign) BOOL buyChildren;  //是否购买儿童票


@property (nonatomic, copy) NSString *tripDate;  //用户机票的出行日期

/**
 * 判断是否为成人需要根据用户预定机票的出行日期判断，而不是根据当前日期判断
 */
- (PassengerAgeType)checkTypeWithBirthday:(NSString *)birthday;

- (instancetype)copy;

@end
