//
//  HYHomeSummaryRepsonse.m
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYHomeSummaryRepsonse.h"
#import "HYDataManager.h"

@interface HYHomeSummaryRepsonse ()

@property (nonatomic, assign) NSUInteger month_new_member_count;  //本月新增会员
@property (nonatomic, assign) NSUInteger member_count;  //会员总数
@property (nonatomic, assign) CGFloat clearing_receivable;  //管理公司/代理商的上期收益
@property (nonatomic, assign) CGFloat clearing_receivable_count;  //管理公司/代理商的总收益
@property (nonatomic, assign) NSUInteger card_stock;  //会员卡库存
@property (nonatomic, assign) NSUInteger card_count;  //本月新增会员
@property (nonatomic, assign) NSUInteger agency_count;  //代理中心的总数 (*注：该字段只有管理公司才有，代理商没有该字段)
@property (nonatomic, strong) NSString *name;

@end

@implementation HYHomeSummaryRepsonse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        if ([self.jsonDic count] > 0)
        {
            self.month_new_member_count = [GETOBJECTFORKEY(self.jsonDic, @"month_new_member_count", [NSString class]) floatValue];
            
            self.member_count = [GETOBJECTFORKEY(self.jsonDic, @"member_count", [NSString class]) floatValue];
            self.clearing_receivable = [GETOBJECTFORKEY(self.jsonDic, @"clearing_receivable", [NSString class]) floatValue];
            self.clearing_receivable_count = [GETOBJECTFORKEY(self.jsonDic, @"clearing_receivable_count", [NSString class]) floatValue];
            self.card_stock = [GETOBJECTFORKEY(self.jsonDic, @"card_stock", [NSString class]) integerValue];
            self.card_count = [GETOBJECTFORKEY(self.jsonDic, @"card_count", [NSString class]) integerValue];
            self.agency_count = [GETOBJECTFORKEY(self.jsonDic, @"agency_count", [NSString class]) integerValue];
            self.name = GETOBJECTFORKEY(self.jsonDic, @"name", [NSString class]);
            self.code = GETOBJECTFORKEY(self.jsonDic, @"code", [NSString class]);
            self.agency_name = GETOBJECTFORKEY(self.jsonDic, @"agency_name", [NSString class]);
            
            NSString *clearing_agency_to_company_profit = [self.jsonDic objectForKey:@"clearing_agency_to_company_profit"];
            if (clearing_agency_to_company_profit)
            {
                self.clearing_agency_to_company_profit = [clearing_agency_to_company_profit floatValue];
            }
            NSString *clearing_agency_to_company_profit_count = [self.jsonDic objectForKey:@"clearing_agency_to_company_profit_count"];
            if (clearing_agency_to_company_profit_count)
            {
                self.clearing_agency_to_company_profit_count = [clearing_agency_to_company_profit_count floatValue];
            }
        }
    }
    
    return self;
}

@end


@implementation HYHomeSummaryRepsonse (SummaryDisplay)


- (NSString *)cardStockDisplay
{
    NSString *tStock = [NSString stringWithFormat:@"%ld", (long)self.card_stock];
    return tStock;
}

- (NSString *)cardCountDisplay
{
    NSString *tCount = [NSString stringWithFormat:@"%ld张", (long)self.card_count];
    return tCount;
}

- (NSString *)monthMemDisplay
{
    NSString *tNewMemCount = [NSString stringWithFormat:@"%ld名", (long)self.month_new_member_count];
    return tNewMemCount;
}

- (NSString *)memCountDisplay
{
    NSString *tMemCount = [NSString stringWithFormat:@"%ld名", (long)self.member_count];
    return tMemCount;
}

- (NSString *)lastEarningDisplay
{
    NSString *tClear;
    if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
    {
        tClear = [NSString stringWithFormat:@"%.2f元", self.clearing_receivable];
    }
    else
    {
        tClear = [NSString stringWithFormat:@"%.2f元", self.clearing_receivable];
    }
    return tClear;
}

- (NSString *)totalEarningDisplay
{
    NSString *tClearCount;
    if ([HYDataManager sharedManager].userInfo.organType == OrganTypePromoter)
    {
        tClearCount =  [NSString stringWithFormat:@"%.2f元", self.clearing_receivable_count];
    }
    else
    {
        tClearCount =  [NSString stringWithFormat:@"%.2f元", self.clearing_receivable_count];
    }
    return tClearCount;
}

- (NSString *)agencyCountDisplay
{
    NSString *tAgencyCount = [NSString stringWithFormat:@"%ld", (long)self.agency_count];
    return tAgencyCount;
}

- (NSString *)agencyNameDisplay
{
    NSString *tName = [NSString stringWithFormat:@"%@", self.agency_name];
    return tName;
}

- (NSString *)codeDisplay
{
    NSString *code = self.code.length > 0 ? [self code] : @"";
    NSString *tName = [NSString stringWithFormat:@"%@", code];
    return tName;
}


@end
