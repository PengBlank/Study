//
//  HYPromotersListRequsetParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//操作员列表
#import "HYRowDataRequest.h"
#import "HYPromotersListResponse.h"

@interface HYPromotersListRequsetParam : HYRowDataRequest

@property (nonatomic, copy) NSString *promoters;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *end_time;

@end


/*
【promoters】	INT	操作员会员ID
【code】	INT	邀请码
【start_time】	DATE	创建起始时间
【end_time】	DATE	创建结束时间
*/