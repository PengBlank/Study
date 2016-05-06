//
//  HYVIPMemberInfo.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  会员信息
 */
@interface HYVIPMemberInfo : NSObject

@property (nonatomic, strong) NSString *number; //会员卡号
@property (nonatomic, strong) NSString *real_name;  //真实姓名
@property (nonatomic, strong) NSString *phone_mob;  //电话
@property (nonatomic, strong) NSString *id_card;    //身份证号
@property (nonatomic, strong) NSString *name;   //运营中心名称
@property (nonatomic, strong) NSString *m_id;   //未知，id号
@property (nonatomic, strong) NSString *enterprise_name;
@property (nonatomic, strong) NSString *promoters_name;
@property (nonatomic, strong) NSString *reg_time;
- (id)initWithData:(NSDictionary *)data;

@end
