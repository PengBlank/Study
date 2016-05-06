//
//  HYVIPListRequestParma.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//
/*
 * 会员列表
 */
#import "HYRowDataRequest.h"
#import "HYVIPListResponse.h"

@interface HYVIPListRequestParma : HYRowDataRequest

//可选字段
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *promoters;
@property (nonatomic, strong) NSDate *fromdate;
@property (nonatomic, strong) NSDate *todate;

@end
