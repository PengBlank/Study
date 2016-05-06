//
//  HYCompanyIncomeInfo.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  运营公司收益信息
 */

@interface HYCompanyIncomeInfo : NSObject

@property (nonatomic, strong) NSString *company_id; //管理公司id
@property (nonatomic, strong) NSString *clearing_time;  //结算时间
@property (nonatomic, strong) NSString *start_time;     //结算开始时间
@property (nonatomic, strong) NSString *end_time;       //结算结否时间
@property (nonatomic, assign) CGFloat receivable;       //应收款
@property (nonatomic, assign) CGFloat payable;          //应付款
@property (nonatomic, strong) NSString *company_name;   //管理公司名称
@property (nonatomic, strong) NSString *m_id;
@property (nonatomic, strong) NSString *clearing_period;

- (id)initWithData:(NSDictionary *)data;

@end
