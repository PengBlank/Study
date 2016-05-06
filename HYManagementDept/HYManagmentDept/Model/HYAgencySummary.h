//
//  HYAgencySummary.h
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYAgencySummary : NSObject

@property (nonatomic, strong) NSString *name;   //中心名
@property (nonatomic, assign) NSInteger month_new_member_count; //本月新增的会员
@property (nonatomic, assign) NSInteger member_count;   //会员总数
@property (nonatomic, assign) CGFloat clearing_agency;  //中心的上期收益
@property (nonatomic, assign) CGFloat agency_receivable_count;  //中心总收益
@property (nonatomic, strong) NSString *card_stock; //会员卡库存
@property (nonatomic, strong) NSString *card_count; //会员卡总数
@property (nonatomic, assign) CGFloat clearing_agency_to_company_profit;    //上期创利
@property (nonatomic, assign) CGFloat clearing_agency_to_company_profit_count;  //总创利

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
