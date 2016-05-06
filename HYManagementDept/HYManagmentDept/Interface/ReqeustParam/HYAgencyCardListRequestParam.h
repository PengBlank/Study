//
//  HYAgencyCardListRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * ）代理运营中心的会员卡列表
 */

#import "HYRowDataRequest.h"
#import "HYAgencyCardListResponse.h"

@interface HYAgencyCardListRequestParam : HYRowDataRequest

//必须字段
@property (nonatomic, copy) NSString *agency_id;  //代理运营中心ID

//可选字段
@property (nonatomic, copy) NSString *number;  //会员卡号

@end
