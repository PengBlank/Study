//
//  HYAgencyOrderListRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-13.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/**
 * 代理运营公司、代理运营中心订单列表
 */

#import "HYBaseRequestParam.h"
#import "HYRowDataRequest.h"
#import "HYAgencyOrderListResponse.h"
#include "HYOrderTypes.h"

@interface HYAgencyOrderListRequestParam : HYRowDataRequest

//必须字段
@property (nonatomic, copy) NSString *start_time;  //结算开始时间戳
@property (nonatomic, copy) NSString *end_time;  //结算结算时间戳
@property (nonatomic, assign) OrderType type;  //1：商城，2：鲜花，3：机票，4：酒店， 5：在线购卡， 6：团购， 7：会员续保
@property (nonatomic, copy) NSString *company_id;  //代理运营中心ID
@property (nonatomic, copy) NSString *agency_id;  //代理运营中心ID
@property (nonatomic, copy) NSString *promoters_id;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *promoters;    //推广员名称
@property (nonatomic, copy) NSString *order_no;

//可选字段

@end
