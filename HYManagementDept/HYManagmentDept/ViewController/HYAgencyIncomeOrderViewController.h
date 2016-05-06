//
//  HYAgencyIncomeOrderViewController.h
//  HYManagmentDept
//
//  Created by RayXiang on 14-5-19.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYBaseDetailViewController.h"
#import "HYAgencyIncomeInfo.h"
#import "HYCompanyIncomeInfo.h"
#import "HYPromoterEarning.h"


typedef enum {
    IncomeTypeCompany,
    IncomeTypeAgency,
    IncomeTypePromoter
} IncomeType;

/**
 *  收益的订单详情
 */
@interface HYAgencyIncomeOrderViewController : HYBaseDetailViewController

@property (nonatomic, strong) HYAgencyIncomeInfo *agencyIncomeInfo;
@property (nonatomic, strong) HYCompanyIncomeInfo *companyIncomeInfo;
@property (nonatomic, strong) HYPromoterEarning *promoterIncome;


@end
