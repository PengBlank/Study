//
//  HYVIPCradListRequestParam.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//
/*
 * 会员卡列表
 */
#import "HYRowDataRequest.h"
#import "HYVIPCardListRespnse.h"

@interface HYVIPCardListRequestParam : HYRowDataRequest
//可选字段
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *promoters;
@property (nonatomic, assign) NSInteger status; //1未激活 2已激活
@property (nonatomic, strong) NSString *start_time; //激活起始
@property (nonatomic, strong) NSString *end_time;
@end
