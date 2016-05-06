//
//  HYAgencyListRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * ）代理运营中心列表
 */

#import "HYRowDataRequest.h"
#import "HYAgencyListResponse.h"

@interface HYAgencyListRequestParam : HYRowDataRequest

//必须字段
@property (nonatomic, copy) NSString *agecny_name;  //运营中心名称

//可选字段

@end
