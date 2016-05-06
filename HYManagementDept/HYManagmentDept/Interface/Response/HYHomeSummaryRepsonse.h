//
//  HYHomeSummaryRepsonse.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseResponse.h"

@interface HYHomeSummaryRepsonse : HYBaseResponse

@property (nonatomic, readonly, assign) NSUInteger month_new_member_count;  //本月新增会员
@property (nonatomic, readonly, assign) NSUInteger member_count;  //会员总数
@property (nonatomic, readonly, assign) CGFloat clearing_receivable;  //管理公司/代理商的上期收益
@property (nonatomic, readonly, assign) CGFloat clearing_receivable_count;  //管理公司/代理商的总收益
@property (nonatomic, readonly, assign) NSUInteger card_stock;  //会员卡库存
@property (nonatomic, readonly, assign) NSUInteger card_count;  //会员卡总数
@property (nonatomic, readonly, assign) NSUInteger agency_count;  //代理中心的总数 (*注：该字段只有管理公司才有，代理商没有该字段)
@property (nonatomic, assign) CGFloat clearing_agency_to_company_profit;
@property (nonatomic, assign) CGFloat clearing_agency_to_company_profit_count;
@property (nonatomic, readonly, strong) NSString *name; //机构名称
@property (nonatomic, strong) NSString *code;   //邀请码
@property (nonatomic, strong) NSString *agency_name;    //所属中心名

@end

@interface HYHomeSummaryRepsonse (SummaryDisplay)
@property (nonatomic, readonly) NSString *cardStockDisplay;
@property (nonatomic, readonly) NSString *cardCountDisplay;
@property (nonatomic, readonly) NSString *monthMemDisplay;
@property (nonatomic, readonly) NSString *memCountDisplay;
@property (nonatomic, readonly) NSString *lastEarningDisplay;
@property (nonatomic, readonly) NSString *totalEarningDisplay;
@property (nonatomic, readonly) NSString *agencyCountDisplay;
@property (nonatomic, readonly) NSString *agencyNameDisplay;
@property (nonatomic, readonly) NSString *codeDisplay;

//- (NSArray *)displayWithIndexPath:(NSIndexPath *)path;

@end
