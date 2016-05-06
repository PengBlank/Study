//
//  HYAgencyIncomeOrderListRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYAgencyOrderListRequestParam.h"
#import "HYAgencyIncomeOrderListResponse.h"

@interface HYAgencyIncomeOrderListRequestParam : HYAgencyOrderListRequestParam

@property (nonatomic, copy) NSString *group;  //代理运营中心ID

@end
