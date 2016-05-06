//
//  HYUserInfo.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 用户信息
 */
#import <Foundation/Foundation.h>

/**
 *  机构类型,
 *  公司,
 *  运营中心
 */
typedef enum
{
    OrganTypeCompany = 0,
    OrganTypeAgency,
    OrganTypePromoter,
    OrganTypeUnkown
}OrganType;

@interface HYUserInfo : NSObject

@property (nonatomic, copy) NSString *user_id;    //用户ID
@property (nonatomic, copy) NSString *user_name;  //用户名
@property (nonatomic, copy) NSString *email;      //邮箱
@property (nonatomic, copy) NSString *real_name;  //买家名
@property (nonatomic, copy) NSString *number;     //会员卡号
@property (nonatomic, copy) NSString *id_card;    // 身份证
@property (nonatomic, copy) NSString *phone_tel;  //手机
@property (nonatomic, copy) NSString *phone_mob;  //电话
@property (nonatomic, copy) NSString *ast_login;  //最后登录时间
@property (nonatomic, copy) NSString *last_ip;    //最后登录IO
@property (nonatomic, copy) NSString *points;     //特币

@property (nonatomic, copy) NSString* order_pending; //
@property (nonatomic, copy) NSString* order_shipped;  //
@property (nonatomic, copy) NSString* order_finished;  //
@property (nonatomic, copy) NSString* order_sum;  //

@property (nonatomic, copy) NSString* is_company; //代理运营公司ID
@property (nonatomic, copy) NSString* is_agency;  //代理运营中心ID
@property (nonatomic, copy) NSString* is_promoters;  //代理运营中心ID

@property (nonatomic, strong) NSString *user_pass;

- (id)initWithData:(NSDictionary *)data;

@property (nonatomic, assign) OrganType organType;

@end
