//
//  HYOrderIncomInfo.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYOrderIncomInfo : NSObject

@property (nonatomic, copy) NSString *order_sn;   //订单号
@property (nonatomic, copy) NSString *company_name;  //代理运营公司名称
@property (nonatomic, copy) NSString *agency_name;   //代理运营中心名称
@property (nonatomic, copy) NSString *order_amount;  //订单金额
@property (nonatomic, copy) NSString *agency_profit;  //代理运营中心收益
@property (nonatomic, copy) NSString *company_profit;  //代理运营公司收益
@property (nonatomic, copy) NSString *promoters_profit;
@property (nonatomic, copy) NSString *order_create_time;  //订单下单时间
@property (nonatomic, copy) NSString *number;  //会员卡号
@property (nonatomic, copy) NSString *order_brief;  //订单详情
@property (nonatomic, copy) NSString *promoters_real_name;  //操作员名称
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *type;

- (id)initWithData:(NSDictionary *)data;

@end
