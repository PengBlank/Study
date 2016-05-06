//
//  HYAgencyInfo.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 代理中心的基本信息
 */

#import <Foundation/Foundation.h>

@interface HYAgencyInfo : NSObject

@property (nonatomic, copy) NSString *name;   //代理运营中心名称
@property (nonatomic, copy) NSString *tel;  //代理运营中心电话
@property (nonatomic, copy) NSString *address;      //代理运营中心地址
@property (nonatomic, copy) NSString *bank_account;  //代理运营中心银行账户
@property (nonatomic, copy) NSString *bank_name;  //银行名称
@property (nonatomic, copy) NSString *payee;  //收款人
@property (nonatomic, copy) NSString *type;  //代理运营中心类型
@property (nonatomic, copy) NSString *company_name;  //所属代理运营公司
@property (nonatomic, strong) NSString *m_id;   //id

- (id)initWithData:(NSDictionary *)data;

@end
