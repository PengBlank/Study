//
//  HYAgencyIncomeInfo.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-16.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAgencyIncomeInfo : NSObject

@property (nonatomic, strong) NSString *agency_name;        //运营中心名称
@property (nonatomic, strong) NSString *clearing_period;    //结算周期
@property (nonatomic, assign) CGFloat receivable;           //应付款
@property (nonatomic, strong) NSString *clearing_time;      //结算时间
@property (nonatomic, strong) NSString *start_time;         //结算开始时间戳
@property (nonatomic, strong) NSString *end_time;           //结算结束时间戳
@property (nonatomic, strong) NSString *m_id;

- (id)initWithData:(NSDictionary *)data;
@end
