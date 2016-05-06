//
//  HYAddAgencyRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * ）添加代理运营中心
 */

#import "HYBaseRequestParam.h"
#import "HYAddAgencyResponse.h"

@interface HYAddAgencyRequestParam : HYBaseRequestParam

//必须字段
@property (nonatomic, copy) NSString *company_id;  //管理公司ID
@property (nonatomic, copy) NSString *agency_name;  //代理中心名称
@property (nonatomic, copy) NSString *agency_tel;  //代理中心电话
@property (nonatomic, copy) NSString *agency_address;  //代理中心地址
@property (nonatomic, copy) NSString *agency_bank_accout;  //代理中心银行账号
@property (nonatomic, copy) NSString *agency_bank_name;  //代理中心银行名称
@property (nonatomic, copy) NSString *agency_payee;  //收款人
@property (nonatomic, copy) NSString *status;  //代理类型   0:代理  1：顾问（默认代理）

//可选字段

@end
