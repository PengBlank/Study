//
//  HYEarning.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

// 推广员的收益
#import <Foundation/Foundation.h>

@interface HYPromoterEarning : NSObject

@property (nonatomic, strong) NSString *real_name;  //操作员姓名
@property (nonatomic, assign) CGFloat receivable;  //应收款
@property (nonatomic, strong) NSString *clearing_period;  //结算周期
@property (nonatomic, strong) NSString *clearing_time;  //结算时间

@property (nonatomic, strong) NSString *promoters_id;
@property (nonatomic, strong) NSString *start_time;
@property (nonatomic, strong) NSString *end_time;
@property (nonatomic, strong) NSString *payable;
@property (nonatomic, strong) NSString *user_id;


- (id)initWithData:(NSDictionary *)data;

@end
